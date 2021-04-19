package land

import (
	ledgerapi "contract/ledger-api"
	"errors"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

// #########
// HELPERS
// #########
type MockStateList struct {
	mock.Mock
}

func (msl *MockStateList) AddState(state ledgerapi.StateInterface) error {
	args := msl.Called(state)

	return args.Error(0)
}
func (msl *MockStateList) GetState(key string, state ledgerapi.StateInterface) error {
	args := msl.Called(key, state)
	state.(*Land).LandNumber = "someland"

	return args.Error(0)
}
func (msl *MockStateList) UpdateState(state ledgerapi.StateInterface) error {
	args := msl.Called(state)
	return args.Error(0)
}

// #########
// TESTS
// #########

func TestAddLand(t *testing.T) {
	land := new(Land)

	list := new(list)
	msl := new(MockStateList)
	msl.On("AddState", land).Return(errors.New("Called add state correctly"))
	list.stateList = msl

	err := list.AddLand(land)
	assert.EqualError(t, err, "Called add state correctly", "should call state list add sate with land")

}

func TestGetLand(t *testing.T) {
	var land *Land
	var err error

	list := new(list)
	msl := new(MockStateList)
	msl.On("GetState", CreateLandKey("someowner", "someland"), mock.MatchedBy(func(state ledgerapi.StateInterface) bool { _, ok := state.(*Land); return ok })).Return(nil)
	msl.On("GetState", CreateLandKey("someotherowner", "someotherland"), mock.MatchedBy(func(state ledgerapi.StateInterface) bool { _, ok := state.(*Land); return ok })).Return(errors.New("GetState error"))
	list.stateList = msl

	land, err = list.GetLand("someowner", "someland")
	assert.Nil(t, err, "should not error when get state on state list does not erro")
	assert.Equal(t, land.LandNumber, "someland", "shoudl use sate list GetState to fill land")

	land, err = list.GetLand("someotherowner", "someotherland")
	assert.EqualError(t, err, "GetState error", "should return error when state list get state errors")
	assert.Nil(t, land, "should not return land on error")

}

func TestUpdateLand(t *testing.T) {
	land := new(Land)

	list := new(list)
	msl := new(MockStateList)
	msl.On("UpdateState", land).Return(errors.New("Called update state correctly"))
	list.stateList = msl

	err := list.UpdateLand(land)
	assert.EqualError(t, err, "Called update state correctly", "should call state list update state with land")

}

func TestNewStateList(t *testing.T) {
	ctx := new(TransactionContext)
	list := newList(ctx)
	stateList, ok := list.stateList.(*ledgerapi.StateList)

	assert.True(t, ok, "should make statelist of type ledgerapi.StateList")
	assert.Equal(t, "org.nalanet.landlist", stateList.Name, "should set the name for the list")

	expectErr := Deserialize([]byte("bad json"), new(Land))
	err := stateList.Deserialize([]byte("bad json"), new(Land))
	assert.EqualError(t, err, expectErr.Error(), "should call Deserialize when stateList.Deserialize called")
}
