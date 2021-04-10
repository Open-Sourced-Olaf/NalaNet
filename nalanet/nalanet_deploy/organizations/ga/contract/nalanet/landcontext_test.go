package land

import (
	ledgerapi "contract/ledger-api"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestGetLandList(t *testing.T) {
	var tc *TransactionContext
	var expectedLandList *list

	tc = new(TransactionContext)
	expectedLandList = newList(tc)
	actualList := tc.GetLandList().(*list)
	assert.Equal(t, expectedLandList.stateList.(*ledgerapi.StateList).Name, actualList.stateList.(*ledgerapi.StateList).Name, "should configure land list when one not already configured")

	tc = new(TransactionContext)
	expectedLandList = new(list)
	expectedStateList := new(ledgerapi.StateList)
	expectedStateList.Ctx = tc
	expectedStateList.Name = "existing paper list"
	expectedLandList.stateList = expectedStateList
	tc.landList = expectedLandList
	assert.Equal(t, expectedLandList, tc.GetLandList(), "should return set land list when already set")

}
