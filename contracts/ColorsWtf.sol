// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "contracts/ERCF721Full.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ColorsWtf is ERC721Full {
    mapping(string => uint256) nameToId;
    mapping(uint256 => string) idToName;
    mapping(uint256 => uint256) rgbToId;
    mapping(uint256 => uint256) idToRgb;
    mapping(uint256 => string) rgbToHtml;
    uint256[] htmlRgbs;
    string[] htmlNames;

    event ColorCreated(
        address _from,
        uint256 _id,
        uint256 _rgb,
        string _name,
        string _html
    );

    constructor(uint256[] memory _htmlRgbs, string[] memory _htmlNames)
        ERC721Full("ColorsWtf", "Colors")
    {
        _mint(msg.sender, 0);

        htmlRgbs = _htmlRgbs;
        htmlNames = _htmlNames;

        string[5] memory initialNames = [
            "red",
            "green",
            "blue",
            "white",
            "black"
        ];

        uint32[5] memory initialRgbs = [255000000, 255000, 255, 255255255, 0];

        for (uint256 i = 0; i < initialNames.length; ++i) {
            string memory name = initialNames[i];
            uint256 rgb = initialRgbs[i];

            _registerColor(name, rgb);
        }
    }

    function generateSVGImageBase64(uint256 rgb)
        public
        pure
        returns (string memory)
    {
        string memory rgbString = _buildRgbString(rgb);

        // solhint-disable-next-line
        return
            string(
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '<svg width="500" height="500" viewBox="0 0 500 500" xmlns="http://www.w3.org/2000/svg" shape-rendering="crispEdges">'
                            "<style>"
                            ".normal { font: 40px sans-serif; fill: white }"
                            "</style>"
                            '<rect width="500" height="500" style="fill:rgb',
                            rgbString,
                            ';"/>'
                            '<text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" class="normal">',
                            rgbString,
                            "</text>"
                            "</svg>"
                        )
                    )
                )
            );
    }

    function _generateAttributes(uint256 rgb)
        private
        view
        returns (string memory)
    {
        string memory rgbString = _buildRgbString(rgb);
        string memory htmlColor = rgbToHtml[rgb];

        // solhint-disable-next-line
        return
            string(
                abi.encodePacked(
                    "["
                    '{"trait_type":"rgb","value":"',
                    rgbString,
                    '"},'
                    '{"trait_type":"html","value":"',
                    htmlColor,
                    '"},'
                    "]"
                )
            );
    }

    function _sqrt(uint256 y) private pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function _buildRgbString(uint256 rgb)
        private
        pure
        returns (string memory rgbString)
    {
        uint256 b = rgb % 1000;
        uint256 rg = rgb / 1000;
        uint256 g = rg % 1000;
        uint256 r = rg / 1000;

        return
            string(
                abi.encodePacked(
                    "(",
                    Strings.toString(r),
                    ", ",
                    Strings.toString(g),
                    ", ",
                    Strings.toString(b),
                    ")"
                )
            );
    }

    function _findHtmlColor(uint256 rgb)
        public
        view
        returns (string memory htmlColor)
    {
        uint256 min = 10000000;
        uint256 curr = 0;

        uint256 b = rgb % 1000;
        uint256 rg = rgb / 1000;
        uint256 g = rg % 1000;
        uint256 r = rg / 1000;

        uint256 htmlRgb;
        uint256 htmlB;
        uint256 htmlRg;
        uint256 htmlG;
        uint256 htmlR;

        uint256 rDiff;
        uint256 gDiff;
        uint256 bDiff;

        uint256 diff;

        for (uint256 i = 0; i < htmlRgbs.length; ++i) {
            htmlRgb = htmlRgbs[i];
            htmlB = htmlRgb % 1000;
            htmlRg = htmlRgb / 1000;
            htmlG = htmlRg % 1000;
            htmlR = htmlRg / 1000;

            if (r < htmlR) {
                rDiff = (htmlR - r)**2;
            } else {
                rDiff = (r - htmlR)**2;
            }

            if (g < htmlG) {
                gDiff = (htmlG - g)**2;
            } else {
                gDiff = (g - htmlG)**2;
            }

            if (b < htmlB) {
                bDiff = (htmlB - b)**2;
            } else {
                bDiff = (b - htmlB)**2;
            }

            diff = _sqrt(rDiff + gDiff + bDiff);

            if (diff < min) {
                min = diff;
                curr = i;
            }
        }

        return htmlNames[curr];
    }

    function constructTokenURI(string memory name, uint256 rgb)
        public
        view
        returns (string memory)
    {
        string memory image = generateSVGImageBase64(rgb);
        string memory attributes = _generateAttributes(rgb);

        // solhint-disable-next-line
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                "{"
                                '"name": "',
                                name,
                                '",'
                                '"description": "colors.wtf color",'
                                '"image": "data:image/svg+xml;base64,',
                                image,
                                '",'
                                '"attributes": ',
                                attributes,
                                "}"
                            )
                        )
                    )
                )
            );
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Full)
        returns (string memory)
    {
        return constructTokenURI(idToName[tokenId], idToRgb[tokenId]);
    }

    function _registerColor(string memory name, uint256 rgb) private {
        uint256 tokenId = totalSupply();

        idToName[tokenId] = name;
        idToRgb[tokenId] = rgb;
        nameToId[name] = tokenId;
        rgbToId[rgb] = tokenId;

        string memory htmlColor = _findHtmlColor(rgb);
        rgbToHtml[rgb] = htmlColor;

        _mint(msg.sender, tokenId);

        emit ColorCreated(msg.sender, tokenId, rgb, name, htmlColor);
    }

    function _blendChannel(uint256 a, uint256 b)
        private
        pure
        returns (uint256 channel)
    {
        return (a + b) / 2;
    }

    function _buildRgb(
        uint256 r,
        uint256 g,
        uint256 b
    ) private pure returns (uint256 rgb) {
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
    ) public payable {
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
        uint256 colorNew = rgbToId[newRgb];

        require(colorNew == 0, "Color already exists");

        _registerColor(name, newRgb);

        payable(ownerOf(colorId1)).transfer(1 * 1e15);
        payable(ownerOf(colorId2)).transfer(1 * 1e15);
    }

    function getNameFromId(uint256 id)
        public
        view
        returns (string memory name)
    {
        return idToName[id];
    }

    function getRgbFromId(uint256 id) public view returns (uint256 rgb) {
        return idToRgb[id];
    }

    function getIdFromName(string memory name)
        public
        view
        returns (uint256 id)
    {
        return nameToId[name];
    }

    function getIdFromRgb(
        uint256 r,
        uint256 g,
        uint256 b
    ) public view returns (uint256 id) {
        uint256 rgb = _buildRgb(r, g, b);
        return rgbToId[rgb];
    }
}
