

const HDWalletProvider = require('truffle-hdwallet-provider');
const MNEMONIC = process.env.MNEMONIC;
const INFURA_KEY = process.env.INFURA_KEY;

const needsInfura = process.env.npm_config_argv &&
      (process.env.npm_config_argv.includes('matic') ||
       process.env.npm_config_argv.includes('live'));

if ((!MNEMONIC || !INFURA_KEY) && needsInfura) {
  console.error();
  process.exit(0);
}

module.exports = {

  networks: {
    development: {
      host: 'localhost',
      port: 7545,
      gas: 4600000,
      network_id: '*' // Match any network id
    },
    
    matic: {
      provider: () => new HDWalletProvider("insect borrow repair hammer goddess battle matrix group diet satoshi rotate worry", `https://rpc-mumbai.matic.today`),
      network_id: 80001,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },

    live: {
      network_id: 1,
      provider: function() {
        return new HDWalletProvider(
          MNEMONIC,
          "https://mainnet.infura.io/v3/" + INFURA_KEY
        );
      },
      gas: 4000000,
      gasPrice: 20000000000
    }
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    reporter: 'eth-gas-reporter',
    reporterOptions : {
      currency: 'USD',
      gasPrice: 2
    }
  },

  // Configure your compilers
  compilers: {
    solc: {
    version: "0.5.12"
      // docker: tr
    }
  }
};
