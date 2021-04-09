package land

import (
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// Contract chaincode that defines the business logic for managing land

type Contract struct {
	contractapi.Contract
}

// Instantiae does nothing
func (c *Contract) Instantiae() {
	fmt.Println("Instantiated")

}

// Register registers new land and stores it in the world state
func (c *Contract) Register(ctx contractapi.TransactionContextInterface, owner string, landNumber string, registerDateTime string, faceValue int) (*Land, error) {
	land := Land{LandNumber: landNumber, Owner: owner, RegisterDateTime: registerDateTime, FaceValue: faceValue}

	land.SetIssued()

	err := ctx.GetLandList().AddLand(&land)

	if err != nil {
		return nil, err
	}
	return &land, nil
}

// Sell gets the land ready for market. It sets the state of land in trading, which means other people can make offers to buy land.
//TODO: BETTER NAMING HERE.
func Sell(ctx contractapi.TransactionContextInterface, land Land) (*Land, error) {
	land.SetTrading()
	err := ctx.GetLandList().AddLand(&land)

	if err != nil {
		return nil, err
	}
	return &land, nil
}
