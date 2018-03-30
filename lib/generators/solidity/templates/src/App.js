import React, { Component } from 'react'
import getWeb3 from './utils/getWeb3'
import <%= contract_name  %>View from './components/<%= contract_name %>View/<%= contract_name %>View'

import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
import './App.css'


class App extends Component
{

    constructor(props) {
      super(props)

      this.state = {
        web3: null
      }
    }

    componentWillMount() {
      // Get network provider and web3 instance.
      // See utils/getWeb3 for more info.
      getWeb3
      .then(results => {
        this.setState({
          web3: results.web3
        })
      })
      .catch(() => {
        console.log('Error finding web3.')
      })
    }

    render() {
        return (
          <div className="App">
            <nav className="navbar pure-menu pure-menu-horizontal">
                <a href="#" className="pure-menu-heading pure-menu-link"><%= contract_name %></a>
            </nav>

            <main className="container">
              <div className="pure-g">
                <div className="pure-u-1-1">
                  <h1>Smart Contract Example for <%= contract_name %></h1>
                  <p>Your dapp <%= contract_name %> is configured.</p>
                  <<%= contract_name %>View web3={this.state.web3} />
                </div>
              </div>
            </main>
          </div>
        )
    }
}

export default App