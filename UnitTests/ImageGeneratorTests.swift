import XCTest
@testable import DominionCompanion

class ImageGeneratorTests: XCTestCase {
    func testHorizontalCombination() {
        let image = TestData.getCard("Village").image!

        let newImage = ImageGenerator().combineImages([image, image], on: .horizontal)

        XCTAssertEqual(newImage?.size.height, image.size.height)
        XCTAssertEqual(newImage?.size.width, image.size.width * 2)
    }

    func testHorizontalCombinationMixedCards() {
        let image = TestData.getCard("Village").image!
        let image2 = TestData.getCard("Advance").image!

        let newImage = ImageGenerator().combineImages([image, image2], on: .horizontal)

        XCTAssertEqual(newImage?.size.height, image.size.height)
        XCTAssertEqual(newImage?.size.width, image.size.width + image2.size.width)
    }

    func testVerticalCombination() {
        let image = TestData.getCard("Village").image!

        let newImage = ImageGenerator().combineImages([image, image], on: .vertical)

        XCTAssertEqual(newImage?.size.width, image.size.width)
        XCTAssertEqual(newImage?.size.height, image.size.height * 2)
    }

    func testVerticalCombinationMixedCards() {
        let image = TestData.getCard("Village").image!
        let image2 = TestData.getCard("Advance").image!

        let newImage = ImageGenerator().combineImages([image, image2], on: .vertical)

        XCTAssertEqual(newImage?.size.width, image2.size.width)
        XCTAssertEqual(newImage?.size.height, image.size.height + image2.size.height)
    }
}
