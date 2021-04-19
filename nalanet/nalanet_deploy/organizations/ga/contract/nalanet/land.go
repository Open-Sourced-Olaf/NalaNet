package land

import (
	"encoding/json"
	"fmt"

	ledgerapi "contract/ledger-api"
)

// State enum for land
type State uint

const (
	// ISSUED state for when a land has been issued
	ISSUED State = iota + 1
	// TRADING state for when a land is on the market
	TRADING
	// REDEEMED state for when a land has been redeemed
	REDEEMED
)

func (state State) String() string {
	names := []string{"ISSUED", "TRADING", "REDEEMED"}

	if state < ISSUED || state > REDEEMED {
		return "UNKNOWN"
	}

	return names[state-1]
}

// CreateLandKey creates a key for land
func CreateLandKey(owner string, landNumber string) string {
	return ledgerapi.MakeKey(owner, landNumber)
}

// Used for managing the fact status is private but want it in world state
type landAlias Land
type jsonLand struct {
	*landAlias
	State State  `json:"currentState"`
	Class string `json:"class"`
	Key   string `json:"key"`
}

// Land defines a piece of land
// TODO:Might be better to add `DesignatedUse` field
type Land struct {
	LandNumber       string `json:"landNumber"`
	Owner            string `json:"owner"`
	RegisterDateTime string `json:"registerDateTime"`
	FaceValue        int    `json:"faceValue"`
	state            State  `metadata:"currentState"`
	class            string `metadata:"class"`
	key              string `metadata:"key"`
}

type LandWithDesignatedUse struct {
	Land
	DesignatedUse string
}

// UnmarshalJSON special handler for managing JSON marshalling
func (land *Land) UnmarshalJSON(data []byte) error {
	jland := jsonLand{landAlias: (*landAlias)(land)}

	err := json.Unmarshal(data, &jland)

	if err != nil {
		return err
	}

	land.state = jland.State

	return nil
}

// MarshalJSON special handler for managing JSON marshalling
func (l Land) MarshalJSON() ([]byte, error) {
	jl := jsonLand{landAlias: (*landAlias)(&l), State: l.state, Class: "org.nalanet.land", Key: ledgerapi.MakeKey(l.Owner, l.LandNumber)}

	return json.Marshal(&jl)
}

// GetState returns the state
func (land *Land) GetState() State {
	return land.state
}

// SetIssued returns the state to issued
func (land *Land) SetIssued() {
	land.state = ISSUED
}

// SetTrading sets the state to trading
func (land *Land) SetTrading() {
	land.state = TRADING
}

// SetRedeemed sets the state to redeemed
func (land *Land) SetRedeemed() {
	land.state = REDEEMED
}

// IsIssued returns true if state is issued
func (land *Land) IsIssued() bool {
	return land.state == ISSUED
}

// IsTrading returns true if state is trading
func (land *Land) IsTrading() bool {
	return land.state == TRADING
}

// IsRedeemed returns true if state is redeemed
func (land *Land) IsRedeemed() bool {
	return land.state == REDEEMED
}

// GetSplitKey returns values which should be used to form key
func (land *Land) GetSplitKey() []string {
	return []string{land.Owner, land.LandNumber}
}

// Serialize formats the land as JSON bytes
func (land *Land) Serialize() ([]byte, error) {
	return json.Marshal(land)
}

// Deserialize formats the land from JSON bytes
func Deserialize(bytes []byte, land *Land) error {
	err := json.Unmarshal(bytes, land)

	if err != nil {
		return fmt.Errorf("error deserializing land. %s", err.Error())
	}

	return nil
}
