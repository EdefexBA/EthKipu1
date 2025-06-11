# Trabajo Final - Módulo 2

## Contrato subasta

Variables:
Estructura Bid contiene ofertante y monto.

    // Variables and struct for bids
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

Eventos:
    event NewOffer(address bidder, uint256 amount);
    event EndAuction(address winner, uint256 winningBid);
    event PartialWithdraw(address bidder, uint256 amount);

Modificadores:

    // Modifiers
    modifier onlyOwner() {
    }
    modifier auctionActive() {
    }
    modifier hasBids(){
    }
    
    // Initialize the auction. PLEASE SET highestBid AND auctionEndTime!!!
    constructor() {
    }
    
    // Make offer
    function makeOffer() external payable auctionActive {
    }
    
    // Show winner
    function showWinner() external hasBids view returns (address winner, uint256 winningBid) {
    }
    
    // Show all bids
    function showBids() external hasBids view returns (Bid[] memory) {
    }
    
    // Refund
    function refund() external hasBids {
    }
    
    // End auction only for owner
    function endAuction() external onlyOwner {
    }
    
    // Withdraw comissions for the owner
    function withdrawCommissions() external onlyOwner hasBids{
    }
    
    // Get auction status
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
    
    // Get contract info
    function getContractInfo() external view returns (
        address contractOwner, uint256 endTime, bool ended, address currentWinner,
        uint256 currentHighestBid) {
            return (owner, auctionEndTime, auctionEnded, highestBidder, highestBid);
    }

    // Partial refund
    function partialRefund() external auctionActive hasBids {

    }

    // Emergency stop
    function emergencyStop() external onlyOwner {
    }
}
