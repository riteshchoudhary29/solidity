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
            <nav className="navbar navbar-expand-sm bg-dark navbar-dark container-fluid">
              <ul className="navbar-nav">
                <li className="nav-item active">
                  <a className="nav-link" href="#"><%= contract_name %></a>
                </li>
              </ul>
            </nav>

            <main className="container">
              <div className="row">
                <div className="col-sm-12 col-md-6 mx-auto">
                  <h1>Smart Contract Example for <%= contract_name %></h1>
                </div>
              </div>
              <div className="row">
                <div className="col-sm-12 col-md-6 mx-auto">
                  <p>Your dapp <%= contract_name %> is configured.</p>
                </div>
              </div>
              <<%= contract_name %>View web3={this.state.web3} />
            </main>
          </div>
        )
    }
}

export default App