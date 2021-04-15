pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

import { SafeMath } from "@openzeppelin/contracts/math/SafeMath.sol";
import { GreenNFTDataStorages } from "./green-nft-data/commons/GreenNFTDataStorages.sol";
import { GreenNFT } from "./GreenNFT.sol";


/**
 * @notice - This is the storage contract for GreenNFTs
 */
contract GreenNFTData is GreenNFTDataStorages {
    using SafeMath for uint;

    /// Current ID of the Green struct (that meta-data of GreenNFT is saved)
    uint currentGreenId;

    /// Auditor
    address[] public auditors;

    /// All GreenNFTs addresses
    address[] public greenNFTAddresses;

    constructor() public {}


    /**
     * @notice - Save applied data that is not approved by auditors yet
     */
    function saveMetadataOfGreenPreApproval(
        address _projectOwner,
        string memory _projectName, 
        uint _carbonCreditsTotal,
        string memory _auditedReport
    ) public returns (bool) {
        currentGreenPreApprovalId++;

        /// Save metadata of a GreenNFT
        Green memory green = Green({
            greenNFT: _greenNFT,
            projectOwner: _projectOwner,
            projectName: _projectName,
            carbonCreditsTotal: _carbonCreditsTotal,
            carbonCreditsSold: _carbonCreditsSold,
            referenceDocument: _referenceDocument,
            auditedReport: _auditedReport,
            greenNFTStatus: GreenNFTStatus.Applied
        });
        greens.push(green);        
    }

    /**
     * @notice - Save metadata of a GreenNFT
     */
    function saveMetadataOfGreenNFT(
        address[] memory _greenNFTAddresses, 
        GreenNFT _greenNFT, 
        address _projectOwner,
        string memory _projectName, 
        uint _carbonCreditsTotal,
        uint _carbonCreditsSold,
        string memory _referenceDocument,
        string memory _auditedReport
    ) public returns (bool) {
        currentGreenId++;

        /// Save metadata of a GreenNFT
        Green memory green = Green({
            greenNFT: _greenNFT,
            projectOwner: _projectOwner,
            projectName: _projectName,
            carbonCreditsTotal: _carbonCreditsTotal,
            carbonCreditsSold: _carbonCreditsSold,
            referenceDocument: _referenceDocument,
            auditedReport: _auditedReport,
            greenNFTStatus: GreenNFTStatus.Applied
        });
        greens.push(green);

        /// Update GreenNFTs addresses
        greenNFTAddresses.push(address(_greenNFT));
    }

    /**
     * @notice - Update owner address of a GreenNFT by transferring ownership
     */
    function updateOwnerOfGreenNFT(GreenNFT _greenNFT, address _newOwner) public returns (bool) {
        /// Identify green's index
        uint greenIndex = getGreenIndex(_greenNFT);

        /// Update metadata of a GreenNFT
        Green storage green = greens[greenIndex];
        require (_newOwner != address(0), "A new owner address should be not empty");
        //green.ownerAddress = _newOwner;  
        green.projectOwner = _newOwner;
    }

    /**
     * @notice - Update status ("Open" or "Cancelled")
     */
    function updateStatus(GreenNFT _greenNFT, GreenNFTStatus _newStatus) public returns (bool) {
        /// Identify green's index
        uint greenIndex = getGreenIndex(_greenNFT);

        /// Update metadata of a GreenNFT
        Green storage green = greens[greenIndex];
        green.greenNFTStatus = _newStatus;  
        //green.status = _newStatus;  
    }


    ///-----------------
    /// Getter methods
    ///-----------------
    function getGreen(uint greenId) public view returns (Green memory _green) {
        uint index = greenId.sub(1);
        Green memory green = greens[index];
        return green;
    }

    function getGreenIndex(GreenNFT greenNFT) public view returns (uint _greenIndex) {
        address GREEN_NFT = address(greenNFT);

        /// Identify member's index
        uint greenIndex;
        for (uint i=0; i < greenNFTAddresses.length; i++) {
            if (greenNFTAddresses[i] == GREEN_NFT) {
                greenIndex = i;
            }
        }

        return greenIndex;   
    }

    function getGreenByNFTAddress(GreenNFT greenNFT) public view returns (Green memory _green) {
        address GREEN_NFT = address(greenNFT);

        /// Identify member's index
        uint greenIndex = getGreenIndex(greenNFT);

        Green memory green = greens[greenIndex];
        return green;
    }

    function getAllGreens() public view returns (Green[] memory _greens) {
        return greens;
    }


    function getAuditors() public view returns (address[] memory _auditors) {
        return auditors;
    }
    

}