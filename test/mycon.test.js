const MyContract = artifacts.require('scon'); //importing scon.sol

contract('MyContract', (accounts) => { //defining test suite for MyContract (keep)
    let instance;

    before(async () => {
        instance = await MyContract.deployed(); 
        //runs before test executed, making it avaiable for use in test cases
    });

    it('should set the initial message correctly', async () => {
        const message = await instance.message();
        assert.equal(message, 'Hello, World!', 'Initial message is incorrect');
    }); //test that string is equal to Hello World string

    it('should allow setting a new message', async () => {
        await instance.setMessage('New Message', { from: accounts[0] });
        const message = await instance.message();
        assert.equal(message, 'New Message', 'Message not set correctly');
    }); //ensures that a new message can be set with setMessage function (MEW)
});

