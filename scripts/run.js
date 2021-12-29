const main = async () => {
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory = await  hre.ethers.getContractFactory('WavePortal');
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.1"),
    });
    await waveContract.deployed();
    console.log("Contract deployed to:", waveContract.address);
    console.log("Contract deployed by:", owner.address);
    let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log("Contact balance: ", hre.ethers.utils.formatEther(contractBalance));
    let waveCount;
    for(let i = 0;i<5;i++)
    {
        let waveTxn = await waveContract.connect(randomPerson).wave("yo");
        await waveTxn.wait();
        contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
        console.log(
            "Contract balance:",
            hre.ethers.utils.formatEther(contractBalance)
        );
        waveCount = await waveContract.getTotalWaves();
        console.log("Waves:", waveCount.toNumber());
    }
    waveCount = await waveContract.getTotalWaves();
    //await waveContract.getWavesMapping();
    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);
};

const runMain = async () => {
    try{
        await main();
        process.exit(0);
    } catch(error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();