const Web3 = require("web3")
const ERC1155 = require('../build/contracts/ERC1155.json')


const init = async () => {
    const web3 = new Web3('http://127.0.0.1:9545')

    const id = await web3.eth.net.getId()
    const deployedNetwork = ERC1155.networks[id]
    const contract = new web3.eth.Contract(
        ERC1155.abi,
        deployedNetwork.address
    )

    const address = await web3.eth.getAccounts()
    
    //minting tokens
    await contract.methods.mint(20, 100).send({from: address[1]})
    console.log(await contract.methods.balanceOf(address[1], 20).call({from: address[1]}))


    //transfering tokens
    await contract.methods.safeTransferFrom(address[1], address[2], 20, 50, '0x').send({from: address[1]})
    console.log(await contract.methods.balanceOf(address[2], 20).call({from: address[2]}))
    
    
    // sending ether
    await contract.methods.depositEther().send({
        from: address[1],
        value: "100000"
    })
    console.log(await contract.methods.etherBalanceOf(address[1]).call())
    // sending ether 2
    await web3.eth.sendTransaction({
        from: address[2],
        to: contract.options.address,
        value: "100001"
    })
    console.log(await contract.methods.etherBalanceOf(address[2]).call())

    
}

init()