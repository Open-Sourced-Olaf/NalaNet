package land

import (
	"encoding/json"
	"errors"
	"fmt"
	"testing"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"github.com/hyperledger/fabric-samples/asset-transfer-basic/chaincode-go/chaincode/mocks"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"
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

func TestReadLand(t *testing.T) {
	chaincodeStub := &mocks.chaincodeStub{}
	transactionContext := &mocks.TransactionContext{}
	transactionContext.GetStubReturns(chaincodeStub)

	expectedLand := &chaincodeStub.Asset{ID: "someland:someowner"}
	bytes, err := json.Marshal(expectedLand)
	require.NoError(t, err)

	chaincodeStub.GetSTateReturns(bytes, nil)
	landContract := Contract{}
	land, err := landContract.ReadLand(transactionContext, "someowner", "someland")
	require.NoError(t, err)
	require.Equal(t, expectedLand, land)

	chaincodeStub.GetSTateReturns(nil, fmt.Errorf("unable to retrieve land"))
	_, err = landContract.ReadLand(transactionContext, "someland", "someowner")
	require.EqualError(t, err, "failed to read from world state: unable to retrieve land")

	chaincodeStub.GetSTateReturns(nil, nil)
	land, err = landContract.ReadLand(transactionContext, "soemland", "someowner")
	require.EqualError(t, err, "the land someland:someowner does not exist")
	require.Nil(t, land)

}
