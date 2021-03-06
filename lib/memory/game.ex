defmodule Memory.Game do
# initialize game state and reset game state
  def new do
   %{
     tiles: shuffledTiles(),
     clicks: 0,
     matchedTiles: 0,
     selectedTile1: nil,
     selectedTile2: nil,
   }
  end
# render the game state
   def client_view(game) do
     %{
       clicks: game.clicks,
       tiles: game.tiles,
       matchedTiles: game.matchedTiles,
       selectedTile1: game.selectedTile1,
       selectedTile2: game.selectedTile2,
     }
   end

  # shuffle the tiles
    def shuffledTiles() do
      tiles = [
          %{letter: "A", index: 0, tileStatus: "hidden"},
          %{letter: "A", index: 1, tileStatus: "hidden"},
          %{letter: "B", index: 2, tileStatus: "hidden"},
          %{letter: "B", index: 3, tileStatus: "hidden"},
          %{letter: "C", index: 4, tileStatus: "hidden"},
          %{letter: "C", index: 5, tileStatus: "hidden"},
          %{letter: "D", index: 6, tileStatus: "hidden"},
          %{letter: "D", index: 7, tileStatus: "hidden"},
          %{letter: "E", index: 8, tileStatus: "hidden"},
          %{letter: "E", index: 9, tileStatus: "hidden"},
          %{letter: "F", index: 10, tileStatus: "hidden"},
          %{letter: "F", index: 11, tileStatus: "hidden"},
          %{letter: "G", index: 12, tileStatus: "hidden"},
          %{letter: "G", index: 13, tileStatus: "hidden"},
          %{letter: "H", index: 14, tileStatus: "hidden"},
          %{letter: "H", index: 15, tileStatus: "hidden"},
       ]
       Enum.shuffle(tiles)
    end   
    #convert the key of the map from string to atom
    def convert_to_atom(tt) do
      for {key, val} <- tt, into: %{}, do: {String.to_atom(key), val}
    end
    # if there's no flipped tile, put the clicked tile into selectedTile1;
    # if there's already one flipped tile, put the clicked tile into selectedTile2;
    # if there's already two flipped tile, click is not allowed
    def clickedOnTile(game, tile) do
     new_tile = convert_to_atom(tile)
     if new_tile.tileStatus != "matched" && !(game.selectedTile1 != nil && game.selectedTile2 != nil) do
       cl = game.clicks + 1
       new_tile1 = Map.put(new_tile, :tileStatus, "selected")
     #change the tileStatus of the selectedTile from "hidden" to "selected"
       if game.selectedTile1 == nil do
         ii = Enum.find_index(game.tiles, fn(x)-> x.index == new_tile1.index end)
         tiles1 = List.replace_at(game.tiles, ii,
         %{
           letter: Enum.at(game.tiles, ii).letter,
           index: Enum.at(game.tiles, ii).index,
           tileStatus: "selected",
           })
         #update the game state 
          Map.put(game, :tiles, tiles1)
          |> Map.put(:clicks, cl)
          |> Map.put(:selectedTile1, new_tile1)
        
       else
          # if clicking on the flipped tile, do nothing 
          # if click on another tile, store it in selectedTile2
          # and change its tileStatus to "selected"
          if new_tile.index != game.selectedTile1.index do
            ii = Enum.find_index(game.tiles, fn(x)-> x.index == new_tile1.index end)
            tiles2 = List.replace_at(game.tiles, ii,
            %{
              letter: Enum.at(game.tiles, ii).letter,
              index: Enum.at(game.tiles, ii).index,
              tileStatus: "selected",
            })
            #update the game status
             Map.put(game, :tiles, tiles2)
             |> Map.put(:clicks, cl)
             |> Map.put(:selectedTile2, new_tile1)

          else
             game
          end
       end
     else
       game
     end
    end

    #to check if the two selected tiles are matched or not
    def checkMatch(game) do
          mt = game.matchedTiles + 1
         index1 = Enum.find_index(game.tiles, fn(x)-> x.index == game.selectedTile1.index end)
        index2 = Enum.find_index(game.tiles, fn(x)-> x.index == game.selectedTile2.index end)
      if game.selectedTile1.tileStatus == "selected" &&
         game.selectedTile2.tileStatus == "selected" do
       # if the two tiles have same letters, they are matched
       # change their tileStatus to "matched" from "selected"
        if game.selectedTile1.letter == game.selectedTile2.letter do
        tiles1 = List.replace_at(game.tiles, index1,
        %{
          letter: Enum.at(game.tiles, index1).letter,
          index: Enum.at(game.tiles, index1).index,
          tileStatus: "matched",
         })
         |>List.replace_at(index2,
         %{
           letter: Enum.at(game.tiles, index2).letter,
           index: Enum.at(game.tiles, index2).index,
           tileStatus: "matched",
         })
         #update the game status to enable to click agian
        %{
           tiles: tiles1,
           clicks: game.clicks,
           matchedTiles: mt,
           selectedTile1: nil,
           selectedTile2: nil,
          } 
        else
        # if the two tiels don't have same letters, face them down
         tiles2 = List.replace_at(game.tiles, index1,
         %{
           letter: Enum.at(game.tiles, index1).letter,
           index: Enum.at(game.tiles, index1).index,
           tileStatus: "hidden",
          })
          |>List.replace_at(index2,
          %{
            letter: Enum.at(game.tiles, index2).letter,
            index: Enum.at(game.tiles, index2).index,
            tileStatus: "hidden",
          })
          #update the game status, and enable to click again
          %{
            tiles: tiles2,
            clicks: game.clicks,
            matchedTiles: game.matchedTiles,
            selectedTile1: nil,
            selectedTile2: nil,
            }
    
          end
      else 
        game
      end
    end

   
end
