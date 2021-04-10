package land

import "github.com/stretchr/testify/mock"

// #########
// HELPERS
// #########
type MockPaperList struct {
	mock.Mock
}

type MockLandList struct {
	mock.Mock
}

func (mll *MockLandList) AddLand(land *Land) error {
	args := mll.Called(land)
	return args.Error(0)
}

//TODO: add tests
