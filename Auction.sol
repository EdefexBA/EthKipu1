// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Auction: smart contract.
/// @author Max Seifert
/// @notice Module 2 of ETH Kipu course.

contract Auction {

    /// @notice Variables and struct for bids
    struct Bid {
        address bidder;
        uint256 amount;
    } 
    address public owner;
    address public highestBidder;
    uint256 public highestBid;
    uint256 public auctionEndTime;
    bool public auctionEnded;
    Bid[] public bids;
    mapping(address => uint256) public deposits;
    
    /// @dev Events

    /// @notice Emits bidder and amount when an offer is made
    event NewOffer(address bidder, uint256 amount);

    /// @notice Emits winner and winning amount at end of the auction
    event EndAuction(address winner, uint256 winningBid);

    /// @notice Emits bidder and amount from a partial withdraw
    event PartialWithdraw(address bidder, uint256 amount);

    /// @dev Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can do this.");
        _;
    }
    modifier auctionActive() {
        require(!auctionEnded && (block.timestamp < auctionEndTime), "The auction has ended.");
        _;
    }
    modifier hasBids(){
        require(bids.length > 0, "There are no registered offers.");
        _;
    }
    
    /// @notice Initialize the auction. PLEASE SET highestBid AND auctionEndTime!!!
    constructor() {
        owner = msg.sender;
        highestBidder = owner;
        highestBid = 1 gwei;
        auctionEndTime = block.timestamp + 5 days;
        auctionEnded = false;
    }
    
    /// @notice Make offer
    function makeOffer() external payable auctionActive {
        require(msg.value >= ((highestBid * 105) / 100),
            "Must be at least 5% higher.");        
        highestBidder = msg.sender;
        highestBid = msg.value;
        bids.push(Bid({
            bidder: msg.sender,
            amount: msg.value
        }));
        deposits[msg.sender] += msg.value;
        if (block.timestamp > (auctionEndTime - 10 minutes)) {
            auctionEndTime = block.timestamp + 10 minutes;    // 10 minutes more
        }
        emit NewOffer(msg.sender, msg.value);
    }
    
    /// @notice Show winner
    function showWinner() external hasBids view returns (address winner, uint256 winningBid) {
        require(auctionEnded || (block.timestamp >= auctionEndTime), "The auction is still active.");
        return (highestBidder, highestBid);
    }
    
    /// @notice Show all bids
    function showBids() external hasBids view returns (Bid[] memory) {
        return bids;
    }
    
    /// @notice Refund
    function refund() external hasBids {
        require(auctionEnded || block.timestamp >= auctionEndTime, "The auction is still active.");
        uint256 i = 0;
        uint256 len = bids.length;
        for (; i < len; i++) {
            uint256 depositAmount = deposits[bids[i].bidder];
            if (highestBidder == bids[i].bidder) {
                depositAmount -= highestBid;    // The winner cannot refund his last offer
            }
            deposits[bids[i].bidder] -= depositAmount;
            payable(bids[i].bidder).transfer((depositAmount * 98) / 100);
        }
    }
    
    /// @notice End auction only for owner
    function endAuction() external onlyOwner {
        require(!auctionEnded, "The auction has now ended.");
        require(block.timestamp >= auctionEndTime, "The auction is still active.");
        auctionEnded = true;
        emit EndAuction(highestBidder, highestBid);
    }
    
    /// @notice Withdraw comissions for the owner
    function withdrawCommissions() external onlyOwner hasBids{
        require(auctionEnded || block.timestamp >= auctionEndTime, "The auction is still active.");
        uint256 balance = address(this).balance;
        require(balance > 0, "There are no funds to withdraw.");        
        payable(owner).transfer(balance);
    }
    
    /// @notice Get auction status
    function getAuctionStatus() external view returns (
        bool isActive, uint256 timeRemaining, uint256 totalBids, uint256 contractBalance
    ) {
        bool active = (block.timestamp < auctionEndTime) && !auctionEnded;
        uint256 remaining = 0;        
        if (block.timestamp < auctionEndTime) {
            remaining = auctionEndTime - block.timestamp;
        }
        return (active, remaining, bids.length, address(this).balance);
    }
    
    /// @notice Get contract info
    function getContractInfo() external view returns (
        address contractOwner, uint256 endTime, bool ended, address currentWinner,
        uint256 currentHighestBid) {
            return (owner, auctionEndTime, auctionEnded, highestBidder, highestBid);
    }

    /// @notice Partial refund
    function partialRefund() external auctionActive hasBids {

        require(deposits[msg.sender] > 0, "There's no refund for you.");
        uint256 i = bids.length - 1;
        while (i >= 0) {

            // Find bidder
            if (msg.sender == bids[i].bidder) {

                // Find how much to refund
                uint256 lastAmount = bids[i].amount;
                uint256 amountToReturn = deposits[msg.sender] - lastAmount;
                require(amountToReturn > 0, "There're no funds to withdraw.");
                deposits[bids[i].bidder] = lastAmount;
                payable(msg.sender).transfer(amountToReturn); // Refund for the bidder
                emit PartialWithdraw(msg.sender, amountToReturn);
                break;
            }
            i--;
        }
    }

    /// @notice Emergency stop
    function emergencyStop() external onlyOwner {
        auctionEndTime = block.timestamp;
        auctionEnded = true;
        payable(owner).transfer(address(this).balance);
    }
}
