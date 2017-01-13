function duplicates(coreTemp)

uniqueX = unique(CoreTemp);

countOfX = hist(CoreTemp,uniqueX);
indexToRepeatedValue = (countOfX~=1);
repeatedValues = uniqueX(indexToRepeatedValue);
numberOfAppearancesOfRepeatedValues = countOfX(indexToRepeatedValue);

end

