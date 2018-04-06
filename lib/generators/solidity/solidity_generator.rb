# rails generate solidity shoping_cart address:owner uint:total_amount uint:total_items bytes32:user_nane --struct cart_item bytes32:item_name uint256:quantity uint256:price

class SolidityGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)
  
  argument :contract, type: :string, default: "my_contract"
  argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"
  class_option :struct, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"

  def base_path
    "SolidityApps/#{contract_name}"
  end  

  def extract_attribute_info(attr_info = 'address:owner')
    value_mapping = { bool: false, int: 0 , uint: 0, fixed: 0.0, ufixed: 0.0, address: '\'ADD ADDDRESS\'', byte: '"Test"' }
    attribute_default_value = 'ADD DEFAULT VALUE FOR ' << attr_info.first << ' : ' << attr_info.last.camelize(:lower)
    attribute_info = attr_info.split(":")
    attribute_type_info = attribute_info.first.scan(/u?int|u?fixed|byte|address|bool/).first
     attribute_type_info

    attribute_type = attribute_info.first
    attribute_name = attribute_info.last.camelize(:lower)
    attribute_value = value_mapping[attribute_type_info.to_sym] || attribute_default_value
    [attribute_type, attribute_name, attribute_value]  
  end

  def extract_attributes(attributes_list = [], add_attributes = [], remove_attributes = [])
    (attributes_list + add_attributes - remove_attributes).collect{|attr_info| extract_attribute_info(attr_info) }.compact 
  end


  # contract helper methods

  def contract_name
    contract.camelize
  end

  def contract_name_lower
    contract.camelize(:lower)
  end

  def contract_attributes_raw
    attributes
  end

  def contract_attributes(add_attributes = [], remove_attributes = [])
    extract_attributes(contract_attributes_raw, add_attributes, remove_attributes).collect do |attribute_info| 
      if block_given?
        yield(attribute_info[0], attribute_info[1], attribute_info[2]) 
      else  
        attribute_info
      end 
    end  
  end


  def contract_attributes_declaration
    contract_attributes([],['address:owner']){ |attr_type, attr_name, attr_value| "#{attr_type} public #{attr_name};" } 
  end

  def contract_attributes_parameters
    contract_attributes{ |attr_type, attr_name, attr_value| "#{attr_type} _#{attr_name}" } 
  end

  def contract_attributes_assignment
    contract_attributes{ |attr_type, attr_name, attr_value| "#{attr_name} = _#{attr_name};" } 
  end

  def contract_attributes_parameter_values
    contract_attributes{ |attr_type, attr_name, attr_value| attr_value  } 
  end

  # struct helper methods

  def struct_name?
    !options['struct'].blank?
  end
    
  def struct_name
    (options['struct'].first || 'struct_entity').camelize
  end

  def struct_name_lower
    (options['struct'].first || 'struct_entity').camelize(:lower)
  end

  def struct_name_mapping
    struct_name_lower.pluralize
  end

  def struct_address_attribute
    "#{struct_name_lower}Address"
  end  

  def struct_attributes_raw
    (options['struct'][1..-1]||[])
  end

  def struct_attributes(add_attributes = [], remove_attributes = [])
    extract_attributes(struct_attributes_raw, add_attributes, remove_attributes).collect do |attribute_info| 
      if block_given?
        yield(attribute_info[0], attribute_info[1], attribute_info[2]) 
      else  
        attribute_info
      end 
    end  
  end

  def struct_attributes_declaration
    struct_attributes{ |attr_type, attr_name, attr_value| "#{attr_type} #{attr_name};" } 
  end
    
  def struct_attributes_parameters
    struct_attributes{ |attr_type, attr_name, attr_value| "#{attr_type} _#{attr_name}" } 
  end

  def struct_attributes_assignment
    struct_attributes{ |attr_type, attr_name, attr_value| "#{struct_name_lower}.#{attr_name} = _#{attr_name};" } 
  end

  def struct_attributes_parameter_values
    struct_attributes{ |attr_type, attr_name, attr_value| attr_value  } 
  end


  def struct_attributes_for_return
    struct_attributes{ |attr_type, attr_name, attr_value| "#{struct_name_mapping}[_#{struct_address_attribute}].#{attr_name}" } 
  end

  def struct_attributes_for_return_type
    struct_attributes(["address:#{struct_address_attribute}"],[]){ |attr_type, attr_name, attr_value| attr_type } 
  end


  def struct_attributes_js_input
    struct_attributes do |attr_type, attr_name, attr_value| 
      <<-HTML
        <div className='form-group'>
          <label for='input#{attr_name.camelize}'>#{attr_name.humanize}:</label>
          <input type='text' className='form-control' id='input#{attr_name.camelize}' placeholder='Enter #{attr_name.humanize}' name='input#{attr_name.camelize}' ref={ x => this._input#{attr_name.camelize } = x } />
        </div>
      HTML
    end 
  end

  def struct_attributes_js_assignment
    struct_attributes do |attr_type, attr_name, attr_value| "const  #{attr_name}= this._input#{attr_name.camelize}.value" end 
  end

  def struct_attributes_js_parameters
    struct_attributes{ |attr_type, attr_name, attr_value| attr_name } 
  end



  # event helper methods

  def event_name(event_type = :contract)
    { contract: "#{contract_name}Event", struct: "#{struct_name}Event"}[event_type]
  end


  def event_attributes_raw(event_type = :contract)
    { contract: contract_attributes_raw, struct: struct_attributes_raw }[event_type]
  end


  def event_attributes(event_type = :contract, add_attributes = ['bytes32:event_type'], remove_attributes = [])
    extract_attributes(event_attributes_raw(event_type), add_attributes, remove_attributes).collect do |attribute_info| 
      if block_given?
        yield(attribute_info[0], attribute_info[1], attribute_info[2]) 
      else  
        attribute_info
      end 
    end  
  end

  def event_attributes_parameters(event_type = :contract)
    event_attributes(event_type){ |attr_type, attr_name, attr_value| "#{attr_type} _#{attr_name}" } 
  end

  def event_attributes_parameters_passing(event_type = :contract)
    event_attributes(event_type,[]){ |attr_type, attr_name, attr_value| "_#{attr_name}" } 
  end

  def create_contract
    #directory 'solidity_app_template', base_path
    template "README.md", "#{base_path}/README.md"
    template "truffle.js", "#{base_path}/truffle.js"
    template "src/App.js", "#{base_path}/src/App.js"    
    template "src/utils/getWeb3.js", "#{base_path}/src/utils/getWeb3.js"
    template "contract.sol", "#{base_path}/contracts/#{contract_name}.sol"
    template "migrations/2_deploy_contracts.js", "#{base_path}/migrations/2_deploy_contracts.js"
    template "components/TemplateView/TemplateView.js", "#{base_path}/src/components/#{contract_name}View/#{contract_name}View.js"
    template "components/TemplateView/TemplateView.css", "#{base_path}/src/components/#{contract_name}View/#{contract_name}View.css"
    template "test/contract.js", "#{base_path}/test/#{contract_name_lower}.js"
    template "test/TestContract.sol", "#{base_path}/test/Test#{contract_name}.sol"
  end

end