function numberOfAppearancesOfRepeatedValues= duplicates(var)

uniqueX = unique(var);

countOfX = hist(var,uniqueX);
indexToRepeatedValue = (countOfX~=1);
repeatedValues = uniqueX(indexToRepeatedValue);
numberOfAppearancesOfRepeatedValues = countOfX(indexToRepeatedValue);

end

