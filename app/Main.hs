module Main where

import Data.List
import Data.List.Split
import Text.Regex.Posix ((=~))
import Main.Utf8

extractVideoID :: String -> String
extractVideoID url
    | url =~ "v=([a-zA-Z0-9_-]+)" = head (tail (head (url =~ "v=([a-zA-Z0-9_-]+)" :: [[String]])))
    | url =~ "youtu.be/([a-zA-Z0-9_-]+)" = head (tail (head (url =~ "youtu.be/([a-zA-Z0-9_-]+)" :: [[String]])))
    | otherwise = "Invalid YouTube URL"

formatString :: String -> String
formatString input = 
    let parts = splitOn ", " input
    in case parts of
        [a, b] -> "{\"time\":" ++ a ++ ",\"text\":\"" ++ b ++ "\"},"
        _      -> error "Input string is not in the expected format 'a, b'"

formatString2 :: String -> String
formatString2 input = "'[" ++ init (concatMap formatString (lines input)) ++ "]'"

formatString3 :: String -> String
formatString3 input = 
    let parts = splitOn ", " input
    in case parts of
        [a, b] -> "<div class=\"timestamp\" data-time=\"" ++ a ++ "\"><h3>" ++ b ++ "</h3></div>"
        _      -> error "Input string is not in the expected format 'a, b'"

formatString4 :: String -> String
formatString4 input = intercalate "\n" (map formatString3 (lines input))

replace :: String -> String -> String -> String
replace old new = go
  where
    go [] = []
    go str@(x:xs)
      | old `isPrefixOf` str = new ++ go (drop (length old) str)
      | otherwise = x : go xs

escapeQuotes :: String -> String
escapeQuotes = replace "\"" "\\\"" . replace "'" "&#39;"

main :: IO ()
main = withUtf8 $ do
    yt <- readFile "YouTube.txt"
    tp <- readFile "TimePoints.txt"
    ts <- readFile "TimeStamps.txt"

    let tp2 = escapeQuotes tp

    let l1 = "<div id=\"player\" data-video-id=\"" ++ extractVideoID yt ++ "\" data-time-points=" ++ formatString2 tp2 ++ "></div>"
    let l2 = "<div id=\"text-display\" align=\"center\"> </div>"
    let l3 = "<div id=\"timestamps\" markdown>"
    let l4 = formatString4 ts
    let l5 = "</div>"

    let final = intercalate "\n" [l1,l2,l3,l4,l5]
    
    writeFile "New.txt" final
