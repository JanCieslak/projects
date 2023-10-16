package main

import "github.com/hajimehoshi/ebiten/v2"

type Game struct {
}

func (g *Game) Update() error {
	return nil
}

func (g *Game) Draw(s *ebiten.Image) {

}

func (g *Game) Layout(outsideWidth, outsideHeight int) (screenWidth, screenHeight int) {
	return 600, 400
}

func main() {
	game := new(Game)

	if err := ebiten.RunGame(game); err != nil {
		panic(err)
	}
}
