const { expect } = require('chai');

describe('ColorsWtf', function () {
  before(async function () {
    this.ColorsWtf = await ethers.getContractFactory('ColorsWtf');
  });

  beforeEach(async function () {
    this.colors = await this.ColorsWtf.deploy();
    await this.colors.deployed();
  });

  // Test cases
  it('getNameFromId at index 1 returns red', async function () {
    expect(await this.colors.getNameFromId(1)).to.equal('red');
  });

  it('getRgbFromId at index 1 returns 255000000', async function () {
    expect((await this.colors.getRgbFromId(1)).toString()).to.equal('255000000');
  });

  it('getIdFromName "red" returns 1', async function () {
    expect((await this.colors.getIdFromName("red")).toString()).to.equal('1');
  });

  it('getIdFromRgb 255, 0, 0 returns 1', async function () {
    expect((await this.colors.getIdFromRgb(255, 0, 0)).toString()).to.equal('1');
  });

  it('name not existing returns 0', async function () {
    expect((await this.colors.getIdFromName("not exists")).toString()).to.equal('0');
  });

});