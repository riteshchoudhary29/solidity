pragma solidity ^0.4.18;

contract Owned {
  address owner;

  function Owned() public {
    owner = msg.sender;
  }

  modifier onlyOwner {
    require(msg.sender == owner);
    _;
  }
}

contract <%= contract_name  %> is Owned {

  <%= contract_attributes_declaration.join("\n  ") %>
  <% if struct_name? %>
  struct <%= struct_name %> {    
    <%= struct_attributes_declaration.join("\n    ") %>
  }

  mapping (address => <%= struct_name  %>) <%= struct_name_mapping  %>;
  address[] public <%= struct_name_lower  %>Addresess;
  <% end %>
  event Received(
    address _sender, 
    uint _amount);
  
  event <%= event_name  %>(
    <%= event_attributes_parameters.join(",\n    ")  %>);
  <% if struct_name? %>
  event <%= event_name(:struct)  %>(
    <%= event_attributes_parameters(:struct).join(",\n    ")  %>);
  <% end %>

  function <%= contract_name  %>(
    <%= contract_attributes_parameters.join(",\n    ")  %>) public{

    <%= contract_attributes_assignment.join("\n    ") %> 
  }

  function () public payable {
    emit Received(msg.sender, msg.value);
  }
  <% if struct_name? %>
  function count<%= struct_name  %>Addresess() public view returns(uint) {
    return <%= struct_name_lower  %>Addresess.length;
  }

  function all<%= struct_name  %>Addresess() view public returns(address[]) {
    return <%= struct_name_lower  %>Addresess;
  }

  function get<%= struct_name  %>(address _<%= struct_address_attribute  %>) public view returns(<%= struct_attributes_for_return_type.join(', ') %>) {
    return ( 
      <%= struct_attributes_for_return.join(",\n      ") %>,
      _<%= struct_address_attribute  %>);
  }

  function set<%= struct_name  %>(
    address _<%= struct_address_attribute  %>, 
    <%= struct_attributes_parameters.join(",\n    ") %>) public onlyOwner returns(address) {
    
    <%= struct_name  %> storage <%= struct_name_lower  %> = <%= struct_name_mapping  %>[_<%= struct_address_attribute  %>];
   
    <%= struct_attributes_assignment.join("\n    ") %>
   
    <%= struct_name_lower  %>Addresess.push(_<%= struct_address_attribute  %>) - 1;   
    
    emit <%= event_name(:struct)  %>(      
      <%= event_attributes_parameters_passing(:struct).join(",\n      ") %>,
      "Create <%= struct_name  %>");
    
    return (_<%= struct_address_attribute  %>);
  }
  <% end %>
}
