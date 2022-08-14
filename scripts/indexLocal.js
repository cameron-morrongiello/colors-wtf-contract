const url = "http://127.0.0.1:8545";
const provider = new ethers.providers.JsonRpcProvider(url);
provider.pollingInterval = 100;


async function main () {

  const names = ['Pink', 'Light Pink', 'Hot Pink', 'Deep Pink', 'Pale Violet Red', 'Medium Violet Red', 'Lavender', 'Thistle', 'Plum', 'Orchid', 'Violet', 'Magenta', 'Medium Orchid', 'Dark Orchid', 'Dark Violet', 'Blue Violet', 'Dark Magenta', 'Purple', 'Medium Purple', 'Medium Slate Blue', 'Slate Blue', 'Dark Slate Blue', 'Rebecca Purple', 'Indigo', 'Light Salmon', 'Salmon', 'Dark Salmon', 'Light Coral', 'Indian Red', 'Crimson', 'Red', 'Fire Brick', 'Dark Red', 'Orange', 'Dark Orange', 'Coral', 'Tomato', 'Orange Red', 'Gold', 'Yellow', 'Light Yellow', 'Lemon Chiffon', 'Light Golden Rod Yellow', 'Papaya Whip', 'Moccasin', 'Peach Puff', 'Pale Golden Rod', 'Khaki', 'Dark Khaki', 'Green Yellow', 'Chartreuse', 'Lawn Green', 'Lime', 'Lime Green', 'Pale Green', 'Light Green', 'Medium Spring Green', 'Spring Green', 'Medium Sea Green', 'Sea Green', 'Forest Green', 'Green', 'Dark Green', 'Yellow Green', 'Olive Drab', 'Dark Olive Green', 'Medium Aqua Marine', 'Dark Sea Green', 'Light Sea Green', 'Dark Cyan', 'Teal', 'Cyan', 'Light Cyan', 'Pale Turquoise', 'Aquamarine', 'Turquoise', 'Medium Turquoise', 'Dark Turquoise', 'Cadet Blue', 'Steel Blue', 'Light Steel Blue', 'Light Blue', 'Powder Blue', 'Light Sky Blue', 'Sky Blue', 'Cornflower Blue', 'Deep Sky Blue', 'Dodger Blue', 'Royal Blue', 'Blue', 'Medium Blue', 'Dark Blue', 'Navy', 'Midnight Blue', 'Cornsilk', 'Blanched Almond', 'Bisque', 'Navajo White', 'Wheat', 'Burly Wood', 'Tan', 'Rosy Brown', 'Sandy Brown', 'Golden Rod', 'Dark Golden Rod', 'Peru', 'Chocolate', 'Olive', 'Saddle Brown', 'Sienna', 'Brown', 'Maroon', 'White', 'Snow', 'Honey Dew', 'Mint Cream', 'Azure', 'Alice Blue', 'Ghost White', 'White Smoke', 'Sea Shell', 'Beige', 'Old Lace', 'Floral White', 'Ivory', 'Antique White', 'Linen', 'Lavender Blush', 'Misty Rose', 'Gainsboro', 'Light Gray', 'Silver', 'Dark Gray', 'Dim Gray', 'Gray', 'Light Slate Gray', 'Slate Gray', 'Dark Slate Gray', 'Black']
  const rgbs = [255192203, 255182193, 255105180, 255020147, 219112147, 199021133, 230230250, 216191216, 221160221, 218112214, 238130238, 255000255, 186085211, 153050204, 148000211, 138043226, 139000139, 128000128, 147112219, 123104238, 106090205, 72061139, 102051153, 75000130, 255160122, 250128114, 233150122, 240128128, 205092092, 220020060, 255000000, 178034034, 139000000, 255165000, 255140000, 255127080, 255099071, 255069000, 255215000, 255255000, 255255224, 255250205, 250250210, 255239213, 255228181, 255218185, 238232170, 240230140, 189183107, 173255047, 127255000, 124252000, 255000, 50205050, 152251152, 144238144, 250154, 255127, 60179113, 46139087, 34139034, 128000, 100000, 154205050, 107142035, 85107047, 102205170, 143188143, 32178170, 139139, 128128, 255255, 224255255, 175238238, 127255212, 64224208, 72209204, 206209, 95158160, 70130180, 176196222, 173216230, 176224230, 135206250, 135206235, 100149237, 191255, 30144255, 65105225, 255, 205, 139, 128, 25025112, 255248220, 255235205, 255228196, 255222173, 245222179, 222184135, 210180140, 188143143, 244164096, 218165032, 184134011, 205133063, 210105030, 128128000, 139069019, 160082045, 165042042, 128000000, 255255255, 255250250, 240255240, 245255250, 240255255, 240248255, 248248255, 245245245, 255245238, 245245220, 253245230, 255250240, 255255240, 250235215, 250240230, 255240245, 255228225, 220220220, 211211211, 192192192, 169169169, 105105105, 128128128, 119136153, 112128144, 47079079, 0]
  
  const signer = provider.getSigner(1)

  // const names = ['Pink', 'Light Pink']
  // const rgbs = [255192203, 255182193]

  // const address = '0x5FbDB2315678afecb367f032d93F642f64180aa3';
  const ColorsWtf = await ethers.getContractFactory('ColorsWtf', signer);
  const colors = await ColorsWtf.deploy(rgbs, names);
  await colors.deployed();

  // const value = await colors._findHtmlColor(255255255);
  // console.log(value.toString());
  
  const tx = await colors.blend(255, 0, 0, 0, 255, 0, "boob", {value: ethers.utils.parseEther("0.002")});

  const tokenURI = await colors.tokenURI(6);
  console.log(tokenURI.toString());




}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });