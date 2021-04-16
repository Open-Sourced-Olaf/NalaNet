package land

import (
	"errors"
	"testing"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

// #########
// HELPERS
// #########

type MockLandList struct {
	mock.Mock
}

func (mll *MockLandList) AddLand(land *Land) error {
	args := mll.Called(land)
	return args.Error(0)
}

func (mll *MockLandList) GetLand(owner string, landNumber string) (*Land, error) {
	args := mll.Called(owner, landNumber)

	return args.Get(0).(*Land), args.Error(1)
}

func (mll *MockLandList) UpdateLand(land *Land) error {
	args := mll.Called(land)
	return args.Error(0)
}

type MockTransactionContext struct {
	contractapi.TransactionContext
	landList *MockLandList
}

func (mtc *MockTransactionContext) GetLandList() ListInterface {
	return mtc.landList
}

// #########
// TESTS
// #########
func TestRegister(t *testing.T) {
	var land *Land
	var err error

	mll := new(MockLandList)
	ctx := new(MockTransactionContext)
	ctx.landList = mll

	contract := new(Contract)

	var sentLand *Land

	mll.On("AddLand", mock.MatchedBy(func(land *Land) bool {
		sentLand = land
		return land.Owner == "someowner"
	})).Return(nil)

	mll.On("AddLand", mock.MatchedBy(func(land *Land) bool {
		sentLand = land
		return land.Owner == "someowner"
	})).Return(errors.New("AddLand error"))

	expectedLand := Land{
		LandNumber:       "someland",
		Owner:            "someowner",
		RegisterDateTime: "somedate",
		FaceValue:        1000,
		state:            1,
	}
	land, err = contract.Register(ctx, "someland", "someowner", "somedate", 1000)
	assert.Nil(t, err, "should not error when add land does not fail")
	assert.Equal(t, sentLand, land, "should send the same land as it returns to add land")
	assert.Equal(t, expectedLand, *land, "shoudl correctly configure paper")

	land, err = contract.Register(ctx, "someland", "someowner", "somedate", 1000)
	assert.EqualError(t, err, "AddLand error", "should return error when add land fails")
	assert.Nil(t, land, "should not return land when fails")

}
