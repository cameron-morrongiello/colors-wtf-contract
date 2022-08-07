// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "contracts/ERCF721Full.sol";

contract ColorsWtf is ERC721Full {

    mapping(string  => uint256) nameToId;
    mapping(uint256 => string) idToName;
    mapping(uint256  => uint256) rgbToId;
    mapping(uint256 => uint256) idToRgb;

    event ColorCreated(address _from, uint256 _id, uint256 _rgb, string _name);

    constructor() ERC721Full("ColorsWtf", "Colors"){

        _mint(msg.sender, 0);

        string[5] memory startingNames = [
            "red",
            "blue",
            "green",
            "white",
            "black"
        ];

        uint32[5] memory startingRgbs = [
            255000000,
            255000,
            255,
            255255255,
            0
        ];

        for (uint256 i = 0; i < startingNames.length; ++i )
        {
            string memory name = startingNames[i];
            uint256 rgb = startingRgbs[i];

            _registerColor(name, rgb);
        }
    }
    
    function _registerColor(string memory name, uint256 rgb) private {

        uint256 tokenId = totalSupply();

        idToName[tokenId] = name;
        idToRgb[tokenId] = rgb;
        nameToId[name] = tokenId;
        rgbToId[rgb] = tokenId;
        
        _mint(msg.sender, tokenId);

        emit ColorCreated(msg.sender, tokenId, rgb, name);
    }

    function _blendChannel(uint256 a, uint256 b) private pure returns (uint256 channel) {
        return (a + b) / 2;
    }

    function _buildRgb(uint256 r, uint256 g, uint256 b) private pure returns (uint256 rgb) {
        return (r * 1000000) + (g * 1000) + b;
    }

    function blend(
        uint256 ar, 
        uint256 ag, 
        uint256 ab, 
        uint256 br, 
        uint256 bg, 
        uint256 bb, 
        string memory name
    ) 
        public 
        payable 
    {
        
        require(msg.value == 2 * 1e15);
        require(bytes(name).length > 0, "Invalid name for color");
        require(255 >= ar && ar >= 0, "Invalid red channel for first color");
        require(255 >= ag && ag >= 0, "Invalid green channel for first color");
        require(255 >= ab && ab >= 0, "Invalid blue channel for first color");
        require(255 >= br && br >= 0, "Invalid red channel for second color");
        require(255 >= bg && bg >= 0, "Invalid green channel for second color");
        require(255 >= bb && bb >= 0, "Invalid blue channel for second color");

        uint256 rgbA = _buildRgb(ar, ag, ab);
        uint256 rgbB = _buildRgb(br, bg, bb);

        uint256 colorId1 = rgbToId[rgbA];
        uint256 colorId2 = rgbToId[rgbB];
        uint256 colorId3 = nameToId[name];

        require(colorId1 > 0, "First color does not exist");
        require(colorId2 > 0, "Second color does not exist");
        require(colorId3 == 0, "Color name already exists");

        uint256 r = _blendChannel(ar, br);
        uint256 g = _blendChannel(ag, bg);
        uint256 b = _blendChannel(ab, bb);

        uint256 newRgb = _buildRgb(r, g, b);
        
        _registerColor(name, newRgb);

        payable(ownerOf(colorId1)).transfer(1 * 1e15);
        payable(ownerOf(colorId2)).transfer(1 * 1e15);
        
    }

    function getNameFromId(uint256 id) public view returns (string memory name) {
        return idToName[id];
    }

    function getRgbFromId(uint256 id) public view returns (uint256 rgb) {
        return idToRgb[id];
    }

    function getIdFromName(string memory name) public view returns (uint256 id) {
      return nameToId[name];
    }

     function getIdFromRgb(uint256 r, uint256 g, uint256 b) public view returns (uint256 id) {
      uint256 rgb = _buildRgb(r, g, b);
      return rgbToId[rgb];
    }

}