// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.7;

interface IEvdence {

    function verify(address _signer) external view returns(bool);

    function getSigner(uint256 _index) external view returns(address);

    function getSignerSize() external view returns(uint256);
}

contract Evidence{

    string evidence;

    address[] singers;

    address public fatoryAddr;


    event NewSigbatruresEvidence(string _evi, address _sender);
    event AddRepeatSigbatruresEvidence(string _evi, address _sender);
    event AddSignaturesEvidence(string _evi, address _sender);


    function callVerify(address _signer) public view returns(bool){

        return IEvdence(fatoryAddr).verify(_signer);

    }

    constructor(string memory _evi,address _factory){

        fatoryAddr = _factory;

        require(callVerify(tx.origin),"_signer is not valid");

        evidence = _evi;

        singers.push(tx.origin);

        emit NewSigbatruresEvidence(_evi,tx.origin);
    }

    function getEvidence() view public returns(string memory,address[] memory,address[] memory){

        uint256 iSize = IEvdence(fatoryAddr).getSignerSize();

        address[] memory signerList = new address[](iSize);

        for(uint256 i = 0; i < iSize; i++){

            signerList[i] = IEvdence(fatoryAddr).getSigner(i);
        }

        return (evidence,signerList,singers);
    }
    

    function sign() public  returns(bool){

        require(callVerify(tx.origin),"_signer is not valid");

        if(isSigned(tx.origin)){

            emit AddSignaturesEvidence(evidence,tx.origin);

            return true;

        }

        singers.push(tx.origin);

        emit AddRepeatSigbatruresEvidence(evidence,tx.origin);

        return true;
    }

    function isSigned(address _signer) public view returns(bool){
        for(uint256 i =0;i< singers.length;i++){
            if(singers[i]==_signer){
                return true;
            }
        }
        return false;
    }

    function isAllSigned() public view returns(bool,string memory){

        uint256 iSize = IEvdence(fatoryAddr).getSignerSize();

        for(uint256 i=0;i<iSize;i++){

            if(!isSigned(IEvdence(fatoryAddr).getSigner(i))){
                
               return (false, "");
            }
        }

        return (true,evidence);
    }
}