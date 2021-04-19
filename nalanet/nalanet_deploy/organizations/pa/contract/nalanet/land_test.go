package land

//TODO: ADD MORE TESTS
import (
	ledgerapi "contract/ledger-api"
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestString(t *testing.T) {
	assert.Equal(t, "ISSUED", ISSUED.String(), "should return string for issued")
	assert.Equal(t, "TRADING", TRADING.String(), "should return stinrg for issued")
}

func TestCreateLandKey(t *testing.T) {
	assert.Equal(t, ledgerapi.MakeKey("someowner", "someland"), CreateLandKey("someowner", "someland"), "should return key comprised of passed values")
}
func TestGetState(t *testing.T) {
	land := new(Land)
	land.state = ISSUED

	assert.Equal(t, ISSUED, land.GetState(), "should return set state")
}
func TestSetState(t *testing.T) {
	land := new(Land)
	land.SetIssued()

	assert.Equal(t, ISSUED, land.state, "should set state to issued")
}

func TestSetTrading(t *testing.T) {
	land := new(Land)
	land.SetTrading()

	assert.Equal(t, TRADING, land.state, "should set state to trading")
}

func TestIsIssued(t *testing.T) {
	land := new(Land)

	land.SetIssued()
	assert.True(t, land.IsIssued(), "should be true when status set to issued")

	land.SetTrading()
	assert.False(t, land.IsIssued(), "should be false when status not set to issued")
}

func TestIsTrading(t *testing.T) {
	land := new(Land)

	land.SetTrading()
	assert.True(t, land.IsTrading(), "should be true when status set to trading")

	land.SetRedeemed()
	assert.False(t, land.IsTrading(), "should be false when status not set to trading")
}

func TestGetSplitKey(t *testing.T) {
	land := new(Land)
	land.LandNumber = "someland"
	land.Owner = "someowner"

	assert.Equal(t, []string{"someowner", "someland"}, land.GetSplitKey(), "should return owner and land number as split key")
}

func TestSerialize(t *testing.T) {
	land := new(Land)
	land.LandNumber = "someland"
	land.Owner = "someowner"
	land.RegisterDateTime = "sometime"
	land.FaceValue = 1000
	land.state = TRADING

	bytes, err := land.Serialize()
	assert.Nil(t, err, "should not error on serialize")
	//fmt.Println(string(bytes))
	assert.Equal(t, `{"landNumber":"someland","owner":"someowner","registerDateTime":"sometime","faceValue":1000,"currentState":2,"class":"org.nalanet.land","key":"someowner:someland"}`, string(bytes), "should return JSON formatted value")

}

func TestDeserialize(t *testing.T) {
	var land *Land
	var err error

	goodJson := `{"landNumber":"someland","owner":"someowner","registerDateTime":"sometime","faceValue":1000,"currentState":2,"class":"org.nalanet.land","key":"someowner:someland"}`

	expectedLand := new(Land)
	expectedLand.LandNumber = "someland"
	expectedLand.Owner = "someowner"
	expectedLand.RegisterDateTime = "sometime"
	expectedLand.FaceValue = 1000
	expectedLand.state = TRADING

	land = new(Land)
	err = Deserialize([]byte(goodJson), land)
	assert.Nil(t, err, "should not return error for deserialize")
	assert.Equal(t, expectedLand, land, "should create expected land")

	badJson := `{"landNumber":"someland","owner":"someowner","registerDateTime":"sometime","faceValue":"NaN","currentState":2,"class":"org.nalanet.land","key":"someowner:someland"}`
	land = new(Land)
	err = Deserialize([]byte(badJson), land)
	fmt.Println(err)
	assert.EqualError(t, err, "error deserializing land. json: cannot unmarshal string into Go struct field jsonLand.faceValue of type int", "should return error for bad data")

}
