# Trabajo Final - ETH Kipu Módulo 2

## Auction: smart contract

### Contract variables:

The Bid structure defines the *offer* (bidder and offered amount).

owner is the owner of the contract..

highestBidder is the highest bidder.

highestBid is the maximum amount offered.

auctionEndTime is the moment when the auction ends.

auctionEnded is the flag that indicates that the auction has ended.

Bid[] is an array of the *offers* structure.

deposits is a mapping of how much a bidder has offered.

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

### Events:

event NewOffer(address bidder, uint256 amount): it is emitted when there is an offer (bidder and amount).

event EndAuction(address winner, uint256 winningBid): it is emitted when the owner ends the auction, showing the winner and the offered amount.

event PartialWithdraw(address bidder, uint256 amount): it is emitted when a bidder partially withdraws their offer(s), except for the last one, without charging a fee.

### Modificators:

onlyOwner: functions applicable only to the auction owner.

auctionActive: functions applicable only when the auction is active.

hasBids: functions applicable only when there is at least one bid in the auction.

### Constructor:

When deploying the contract, the base offer must be initialized at *highestBid* and the duration of the auction at *auctionEndTime*.
    
### Functions:

makeOffer: executes the offer if the offered amount exceeds the previous one by 5%.

showWinner: shows the winner and the maximum amount offered.

showBids: show a list of bidders and offered amounts.

refund: it refunds all the offered money, minus a 2% commission. The winning bid is retained for the winner.

endAuction: the owner ends the auction and announces the winner and the maximum amount offered.

withdrawCommissions: the owner withdraws the commission and the winning bid.

getAuctionStatus: it informs the status of the auction (whether it is active, remaining time, total bids, and amount raised up to that moment).

getContractInfo: it informs who the owner is, when the auction ends, if the auction has ended, the highest bidder up to that moment, and the highest amount offered.

partialRefund: a bidder can withdraw previous offers prior to their last offer without incurring a fee.

emergencyStop: only for the owner to use in emergencies. It stops the auction and withdraws all accumulated funds.

<!---
[Dirección del contrato en Sepolia](https://sepolia.etherscan.io/address/)
--->
