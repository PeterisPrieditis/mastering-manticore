import time, sys
from manticore.ethereum import ManticoreEVM, ABI
from manticore.core.smtlib import Operators, Z3Solver
from manticore.utils import config
from manticore.core.plugin import Plugin

start_time = time.time()
m = ManticoreEVM()

# Disable the gas tracking
consts_evm = config.get_group("evm")
consts_evm.oog = "ignore"

# Increase the solver timeout
"""
config.get_group("smt").defaultunsat = False
config.get_group("smt").timeout = 3600
"""

ETHER = 10 ** 18
CONTRACT_FILE_NAME = sys.argv[1]
CONTRACT_NAME = sys.argv[2]

deployer = m.create_account(balance=100 * ETHER, name="deployer")
userFrom = m.create_account(balance=100 * ETHER, name="userFrom")
userTo = m.create_account(balance=100 * ETHER, name="userTo")
print(f'[+] Created user wallet. deployer: {hex(deployer.address)}, userFrom: {hex(userFrom.address)}, userTo: {hex(userTo.address)}')
print(f'- deployer: {hex(deployer.address)}')
print(f'- userFrom: {hex(userFrom.address)}')
print(f'- userTo: {hex(userTo.address)}')

contract = m.solidity_create_contract(CONTRACT_FILE_NAME, contract_name=CONTRACT_NAME, owner=deployer, compile_args={
    "solc_args": "optimize optimize-runs=800 metadata-hash=none"
})
print(f'[+] Deployed contract. address: {hex(contract.address)}')

print(f'[+] Declaring symbolic variables.')
amount = m.make_symbolic_value()

print(f'[+] Calling contract functions sequences.')

# get state before transaction
contract.balanceOf(userFrom.address)

# outline the transactions
m.transaction(caller=userFrom.address, address=contract, value=0, data=m.make_symbolic_buffer(4+32*4))
contract.transfer(userTo.address, amount, caller=userFrom.address)

# get state after transaction
contract.balanceOf(userFrom.address)

print(f'[+] Generating symbolic conditional transactions traces.')
no_bug_found = True
for st in m.ready_states:
    # get state before and after transfer
    balanceFromBefore = ABI.deserialize("uint", st.platform.transactions[0].return_data)
    balanceFromAfter = ABI.deserialize("uint", st.platform.transactions[-1].return_data)
    # withdrawing more than deposited
    condition = balanceFromAfter > balanceFromBefore
    if m.generate_testcase(st, name="BugFound", only_if=condition):
        print(f'Bug found, results are in {m.workspace}')
        no_bug_found = False

if no_bug_found:
    print(f'No bug found')

print(f"[+] Global coverage: {contract.address:x} - {m.global_coverage(contract)}%")
print(f'[+] Results in workspace: {m.workspace}')
#print('[+] Execution time in seconds: ' % (time.time() - start_time))
print('[+] Execution time in seconds:  %s ' % (time.time() - start_time))
