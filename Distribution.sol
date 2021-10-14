pragma solidity ^0.5.0;

import "./Token.sol";

contract Distribution {
	string public name = "Baller Token Exchange";
	Token public token;
	uint public rate = 100;

	event TokensPurchased(
		address account,
		address token,
		uint amount,
		uint rate
	);

	event TokensSold(
		address account,
		address token,
		uint amount,
		uint rate
	);

	constructor (Token _token) public {
		token = _token;
	}

	function buyTokens() public payable {
		uint tokenAmount = msg.value * rate;

		require(token.balanceOf(address(this)) >= tokenAmount);

		token.transfer(msg.sender, tokenAmount);

		//Emit an event
		emit TokensPurchased(msg.sender, address(token),tokenAmount, rate);
	}

	function sellTokens(uint _amount) public {
		//User can't sell more tokens than they have
		require(token.balanceOf(msg.sender) >= _amount);


		//Calc ether amount
		uint etherAmount = _amount / rate;

		//Require that EthSwap has enough Ether
		require (address(this).balance >= etherAmount);

		//Perform sale
		token.transferFrom(msg.sender, address(this), _amount);
		msg.sender.transfer(etherAmount);

		emit TokensSold(msg.sender, address(token), _amount, rate);
	}

}

