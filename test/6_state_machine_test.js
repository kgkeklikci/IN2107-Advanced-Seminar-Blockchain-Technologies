// load compiled contract
const StateMachine = artifacts.require("StateMachine");

// load truffle assertions
const truffleAssert = require("truffle-assertions");

// test contract
contract(StateMachine, (accounts) => {

    // test pattern name
    it("should return pattern name", async () => {
        const deployed = await StateMachine.deployed();
        const instance = await deployed.getInstance();
        assert.equal(instance, "State Machine Pattern");
    });

    // test default state
    it("should return idle state", async () => {
        const deployed = await StateMachine.deployed();
        const state = await deployed.getState();
        assert.equal(state, 0);
    });

    // test backward move from default state
    it("should be rejected by backward modifier", async () => {
        const deployed = await StateMachine.deployed();
        await truffleAssert.reverts(deployed.backward());
    });

    // move to the last state
    it("should return abort state", async () => {
        const deployed = await StateMachine.deployed();
        await deployed.forward();
        await deployed.forward();
        const state = await deployed.getState();
        assert.equal(state, 2);
    });

    // test forward move from last state
    it("should be rejected by forward modifier", async () => {
        const deployed = await StateMachine.deployed();
        await truffleAssert.reverts(deployed.forward());
    });
});