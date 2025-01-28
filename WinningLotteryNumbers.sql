Select top 10 *
From LotteryWinnings

--Count the number of each winning number column

Select [Winning Number 1], Count([Winning Number 1]) as Number_of_Occurrences
From LotteryWinnings
Group by [Winning Number 1]
Order by Count([Winning Number 1]) desc

Select [Winning Number 2], Count([Winning Number 2]) as Number_of_Occurences
From LotteryWinnings
Group by [Winning Number 2]
Order by Count([Winning Number 2]) desc

Select [Winning Number 3], Count([Winning Number 3]) as Number_of_Occurrences
From LotteryWinnings
Group by [Winning Number 3]
Order by Count([Winning Number 3]) desc

Select [Winning Number 4], Count([Winning Number 4]) as Number_of_Occurences
From LotteryWinnings
Group by [Winning Number 4]
Order by Count([Winning Number 4]) desc

Select [Winning Number 5], Count([Winning Number 5]) as Number_of_Occurences
From LotteryWinnings
Group by [Winning Number 5]
Order by Count([Winning Number 5]) desc

Select [Mega Ball], Count([Mega Ball]) as Number_of_Occurences
From LotteryWinnings
Group by [Mega Ball]
Order by Count([Mega Ball]) desc
--

--Find the most frequent occuring winning numbers from each column including the Mega Ball

WITH TopNumbers AS (
    SELECT [Winning Number 1] AS WinningNumber, COUNT([Winning Number 1]) AS Number_of_Occurrences, 'Winning Number 1' AS SourceColumn
    FROM LotteryWinnings
    GROUP BY [Winning Number 1]
    UNION ALL
    SELECT [Winning Number 2], COUNT([Winning Number 2]), 'Winning Number 2'
    FROM LotteryWinnings
    GROUP BY [Winning Number 2]
    UNION ALL
    SELECT [Winning Number 3], COUNT([Winning Number 3]), 'Winning Number 3'
    FROM LotteryWinnings
    GROUP BY [Winning Number 3]
    UNION ALL
    SELECT [Winning Number 4], COUNT([Winning Number 4]), 'Winning Number 4'
    FROM LotteryWinnings
    GROUP BY [Winning Number 4]
    UNION ALL
    SELECT [Winning Number 5], COUNT([Winning Number 5]), 'Winning Number 5'
    FROM LotteryWinnings
    GROUP BY [Winning Number 5]
    UNION ALL
    SELECT [Mega Ball], COUNT([Mega Ball]), 'Mega Ball'
    FROM LotteryWinnings
    Group By [Mega Ball]
)
SELECT WinningNumber, Number_of_Occurrences, SourceColumn
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY SourceColumn ORDER BY Number_of_Occurrences DESC) AS RowNum
    FROM TopNumbers
) RankedNumbers
WHERE RowNum <= 10
ORDER BY SourceColumn, Number_of_Occurrences DESC;

--Check to see if most popular numbers ever won a ticket (2, 17, 31, 46, 52 and MB 9)
--On Jan 19 2016, the winning ticket was 02, 17, 31, 39, 47 and MB 9. That's awfully close. Worth buying at some point.

SELECT [Winning Number 1], Count([Winning Number 1])
FROM Portfolio..LotteryWinnings
Group by [Winning Number 1]
Order by Count([Winning Number 1]) desc

--Are there any rows that have the exact same winnings numbers?

SELECT Count(*)
From LotteryWinnings

Select [Draw Date], COUNT(Distinct([Winning Numbers])) as Number_of_Occurences, [Winning Numbers]
FROM LotteryWinnings
Group by [Draw Date], [Winning Numbers]
Order by [Winning Numbers]

Select *
FROM LotteryWinnings
WHERE [Winning Number 1] = 2 AND [Winning Number 2] = 17