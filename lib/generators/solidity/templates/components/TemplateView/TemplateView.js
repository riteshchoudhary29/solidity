import React, { Component } from 'react'
import './<%= contract_name %>View.css'

import getWeb3 from '../../utils/getWeb3'
import truffleConfig from '../../../truffle.js'

//import <%= contract_name %> from '../../../contracts/<%= contract_name %>.sol'
import <%= contract_name %> from '../../../build/contracts/<%= contract_name %>.json'

class <%= contract_name %>View extends Component
{
    constructor(props) {
        super(props)

        this.state = {
            count<%= struct_name  %>Addresess: 0,
            all<%= struct_name  %>Addresess: [],
            web3: this.props.web3
        }

        this.onClickAdd<%= struct_name %> = this.onClickAdd<%= struct_name %>.bind(this)
        this.onChange<%= struct_name %> = this.onChange<%= struct_name %>.bind(this)
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
      .then(results => {
        console.log(this.state.web3)
      })
      .then(results => {
        this.instantiateContract()
      })
      .catch(() => {
        console.log('Error finding web3.')
      })
    }


    componentDidMount() {
      
    }


    instantiateContract() {
      /*
       * SMART CONTRACT EXAMPLE
       *
       * Normally these functions would be called in the context of a
       * state management library, but for convenience I've placed them here.
       */

      const contract = require('truffle-contract')
      const <%= contract_name_lower %> = contract(<%= contract_name  %>)
      <%= contract_name_lower %>.setProvider(this.state.web3.currentProvider)

      // Declaring this for later so we can chain functions on SimpleStorage.

      // Get accounts.
      this.state.web3.eth.getAccounts((error, accounts) => {
        <%= contract_name_lower %>.deployed().then((instance) => {
          this.setState({ <%= contract_name_lower %>Instance: instance })          
          return this.state.<%= contract_name_lower %>Instance.count<%= struct_name  %>Addresess()
        }).then((result) => {
          this.setState({ count<%= struct_name  %>Addresess: result.c[0] })
          return this.state.<%= contract_name_lower %>Instance.all<%= struct_name  %>Addresess()
        }).then((result) => {
          this.setState({ all<%= struct_name  %>Addresess: result })
        })
      })
    }

    onClickAdd<%= struct_name %>() {
        const gasAmonut = truffleConfig.networks.development.gas
        const  createrAddress = this.state.web3.eth.accounts[0]
        <%= struct_attributes_js_assignment.join("\n        ") %>

        this.state.<%= contract_name_lower %>Instance.set<%= struct_name %>(createrAddress, <%= struct_attributes_js_parameters.join(", ")%>,{ from: createrAddress, value: 0, gas: gasAmonut }).then(result => {
            console.log('set<%= struct_name %> : ', result)
        })
    }

    onChange<%= struct_name %>(evt) {
        this.setState({ sender: evt.target.value })
    }

    render() {
        return (
            <div className="<%= contract_name %>">
              <div className="row">
                <div className="col-sm-12 col-md-6 mx-auto">
                  <h2><%= contract_name %>View</h2>
                </div>
              </div>              
              <div className="row">
                <div className="col-sm-12 col-md-6 mx-auto">
                  <p>Your <%= contract_name %>View is configured and ready to use.</p>
                </div>
              </div>              
              <div className="row">
                <div className="col-sm-12 col-md-6 mx-auto">
                  <h2><%= struct_name.humanize  %> Count : {this.state.count<%= struct_name  %>Addresess}</h2>
                </div>
              </div>
              <div className="row">
                <div className="col-sm-12 col-md-6 mx-auto">
                  <div className='form-group'>
                    <label for='select<%= struct_name %>'>Select <%= struct_name %> (select one):</label>
                    <select onChange={this.onChange<%= struct_name %>} className='form-control' id='select<%= struct_name %>'>
                      {this.state.all<%= struct_name  %>Addresess.map(acct => <option key={acct} value={acct}>{acct}</option>)}
                    </select>
                  </div>
                </div>
              </div>
              <div className="row">
                <div className="col-sm-12 col-md-6 mx-auto">
                  <%= struct_attributes_js_input.join("\n                    ") %>
                </div>
              </div>
              <div className="row">
                <div className="col-sm-12 col-md-6 mx-auto">
                  <button type="button" className="btn btn-primary" onClick={this.onClickAdd<%= struct_name %>}>Add <%= struct_name.humanize %></button>
                </div>
              </div>

            </div>                
        )
    }
}

export default <%= contract_name %>View