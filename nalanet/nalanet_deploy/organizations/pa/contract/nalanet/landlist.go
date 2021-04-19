package land

import ledgerapi "contract/ledger-api"

// ListInterface defines functionality needed to interact with the world state on behalf of nalanet
type ListInterface interface {
	AddLand(*Land) error
	GetLand(string, string) (*Land, error)
	UpdateLand(*Land) error
}

type list struct {
	stateList ledgerapi.StateListInterface
}

func (ll *list) AddLand(land *Land) error {
	return ll.stateList.AddState(land)
}
func (ll *list) GetLand(owner string, landNumber string) (*Land, error) {
	land := new(Land)
	err := ll.stateList.GetState(CreateLandKey(owner, landNumber), land)

	if err != nil {
		return nil, err
	}
	return land, nil
}

func (ll *list) UpdateLand(land *Land) error {
	return ll.stateList.UpdateState(land)
}

// NewList creates a new list from context
func newList(ctx TransactionContextInterface) *list {
	stateList := new(ledgerapi.StateList)
	stateList.Ctx = ctx
	stateList.Name = "org.nalanet.landlist"
	stateList.Deserialize = func(bytes []byte, state ledgerapi.StateInterface) error {
		return Deserialize(bytes, state.(*Land))

	}
	list := new(list)
	list.stateList = stateList
	return list
}
