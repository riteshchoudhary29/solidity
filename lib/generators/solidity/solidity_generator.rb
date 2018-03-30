# rails generate solidity shoping_cart address:owner uint:total_amount uint:total_items bytes32:user_nane --struct cart_item bytes32:item_name uint256:quantity uint256:price

class SolidityGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)
  
  argument :contract, type: :string, default: "my_contract"
  argument :attributes, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"
  class_option :struct, type: :array, default: [], banner: "field[:type][:index] field[:type][:index]"

  def base_path
    "SolidityApps/#{contract_name}"
  end  

  def default_address
    #system("testrpc")
  end  

  # contract helper methods

  def contract_name
    contract.camelize
  end

  def contract_name_lower
    contract.camelize(:lower)
  end

  def contract_attributes
    attributes.collect{|attribute| attribute.split(":") }
  end

  def contract_attributes_without_owner
    contract_attributes.select{|attr_info| !attr_info.last.eql? 'owner'}
  end

  def contract_attributes_declaration
    contract_attributes_without_owner.collect{ |attr_info| "#{attr_info.first} public #{attr_info.last.camelize(:lower) };"}
  end

  def contract_attributes_parameters
    contract_attributes.collect{ |attr_info| "#{attr_info.first} _#{attr_info.last.camelize(:lower) }" }
  end

  def contract_attributes_parameter_values
    contract_attributes.collect do |attr_info| 
      case attr_info.first.scan(/u?int|u?fixed|byte|address|bool/).first
      when 'bool'
        false
      when 'int', 'uint'
        0
      when 'fixed', 'ufixed'
        0.0
      when 'address'
        '\'ADD ADDDRESS\''
      when 'byte'
        '""'
      else
        'ADD DEFAULT VALUE FOR ' << attr_info.first << ' : ' << attr_info.last.camelize(:lower)
      end
    end
  end

  def contract_attributes_assignment
    contract_attributes.collect{ |attr_info| "#{attr_info.last.camelize(:lower)} = _#{attr_info.last.camelize(:lower) };" }
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

  def struct_attributes
    (options['struct'][1..-1]||[]).collect{|attribute| attribute.split(":") }
  end  

  def struct_attributes_with_address
    [['address',struct_address_attribute]] + struct_attributes
  end  

  def struct_address_attribute
    "#{struct_name_lower}Address"
  end  

  def struct_attributes_parameters
    struct_attributes.collect{ |attr_info| "#{attr_info.first} _#{attr_info.last.camelize(:lower) }" }
  end

  def struct_attributes_declaration
    struct_attributes.collect{ |attr_info| "#{attr_info.first} #{attr_info.last.camelize(:lower) };"}
  end

  def struct_attributes_assignment
    struct_attributes.collect{ |attr_info| "#{struct_name_lower}.#{attr_info.last.camelize(:lower)} = _#{attr_info.last.camelize(:lower) };" }
  end

  def struct_attributes_js_input
    struct_attributes.collect{ |attr_info| "<div>#{attr_info.last.humanize} : <input type=\"text\" ref={ x => this._input#{attr_info.last.camelize } = x } /></div>" }
  end

  def struct_attributes_js_assignment
    struct_attributes.collect{ |attr_info| "const #{attr_info.last.camelize(:lower)} = this._input#{attr_info.last.camelize }.value" }
  end

  def struct_attributes_js_parameters
    struct_attributes.collect{ |attr_info| "#{attr_info.last.camelize(:lower) }" }
  end


  def struct_return_attributes
    struct_attributes.collect{ |attr_info| "#{struct_name_mapping}[_#{struct_address_attribute}].#{attr_info.last.camelize(:lower)}"}
  end

  def struct_return_attributes_type
    struct_attributes_with_address.collect{ |attr_info| "#{attr_info.first}"}
  end


  # event helper methods

  def event_name(event_type = :contract)
    send("#{event_type}_name".to_sym) << "Event" 
  end

  def event_attributes(event_type = :contract)
    [['bytes32','event_type']] + send("#{event_type}_attributes".to_sym)
  end

  def event_attributes_parameters(event_type = :contract)
    event_attributes(event_type).collect{ |attr_info| "#{attr_info.first} _#{attr_info.last.camelize(:lower) }" }
  end

  def event_attributes_parameters_passing(event_type = :contract)
    send("#{event_type}_attributes".to_sym).collect{ |attr_info| "_#{attr_info.last.camelize(:lower) }" }
  end



  def create_contract
    directory 'solidity_app_template', base_path
    template "contract.sol", "#{base_path}/contracts/#{contract_name}.sol"
    template "README.md", "#{base_path}/README.md"
    template "truffle.js", "#{base_path}/truffle.js"  
    template "migrations/2_deploy_contracts.js", "#{base_path}/migrations/2_deploy_contracts.js"
    template "src/App.js", "#{base_path}/src/App.js"    
    template "src/utils/getWeb3.js", "#{base_path}/src/utils/getWeb3.js"
    template "components/TemplateView/TemplateView.js", "#{base_path}/src/components/#{contract_name}View/#{contract_name}View.js"
    template "components/TemplateView/TemplateView.css", "#{base_path}/src/components/#{contract_name}View/#{contract_name}View.css"
  end

end