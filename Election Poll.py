import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns 

# Import election data set
elections = pd.read_csv('electionpoll.csv')


# Print the first few rows of the data set
print(elections.head())
print(elections.columns)


# Find the arithmetic mean, median, standard deviation of the Workers' Party column
workers_mean = elections["Workers' Party"].mean()
print('Workers Party mean =' + str(workers_mean))

workers_median = elections["Workers' Party"].median()
print('Workers Party median =' + str(workers_median))

workers_std = elections["Workers' Party"].std()
print('Workers Party std =' + str(workers_std))


# Find the range of the Workers' Party column for the month of March 2019
march = elections[(elections['Date \ Party'] <= '3/31/2019') & (elections['Date \ Party'] >= '3/1/2019')]

workers_range = march["Workers' Party"].max() - march["Workers' Party"].min()
print('Workers Party range =' + str(workers_range))


# Find the highest number of votes for each party 
print(elections.max())
print(elections.min())


# What day did the Civic Party get the most votes?
highest = elections[elections['Civic Party'] == 37]
print(highest)


#Create, in one plot, a bar chart, a histogram, and a boxplot for the Workers' Party column
plt.subplot(1, 3, 1)
plt.bar(elections['Date \ Party'], elections['Workers\' Party'])
plt.subplot(1, 3, 2)
plt.hist(elections['Workers\' Party'], bins = 10, color = 'blue') 
plt.axvline(workers_mean, color='r', linestyle='solid', linewidth=2)
plt.text(workers_mean, 50, f'Mean: {workers_mean:.2f}', color='black', ha='center', va='center', rotation = 90) 
plt.subplot(1, 3, 3)
plt.boxplot(elections['Workers\' Party']) 
plt.suptitle('Workers Party Analytics')
plt.show()
plt.clf()


#   Create a for loop that takes in a column and creates a bar chart, histogram, and boxplot
#   First, create a list of column names

columns = list(elections.columns)
print(columns)

columns.pop(0)

# print(columns)

# for column in columns:
#     plt.subplot(1, 3, 1)
#     plt.bar(elections['Date \ Party'], elections[column])
#     plt.subplot(1, 3, 2)
#     plt.hist(elections[column], bins = 10, color = 'blue') 
#     plt.axvline(elections[column].mean(), color='r', linestyle='solid', linewidth=2) 
#     plt.subplot(1, 3, 3)
#     plt.boxplot(elections[column]) 
#     plt.suptitle('{} Analytics'.format(column))
#     plt.show()
#     plt.clf()

#   Edit the for loop to change the sizes of the subplots to make it easier to see

for column in columns:
    f = plt.figure(figsize=(15,5))
    ax = f.add_subplot(131)
    ax2 = f.add_subplot(132)
    ax3 = f.add_subplot(133)
    ax.bar(elections['Date \ Party'], elections[column])
    ax2.hist(elections[column], bins = 10, color = 'blue') 
    ax2.axvline(elections[column].mean(), color='r', linestyle='solid', linewidth=2) 
    ax3.boxplot(elections[column])
    f.suptitle('{} Analytics'.format(column))
    plt.show()
    plt.clf()


#   If each day counted as a separate election, which party would have won the most elections?

#   Create a new column that shows the winner of each day

elections['Max Votes'] = elections.drop(columns = ['Date \ Party']).max(axis=1)
elections['Winner'] = elections.drop(columns = ['Date \ Party']).idxmax(axis=1)
print(elections['Winner'].value_counts())
print(max(elections['Winner'].value_counts()))

#   If each day counted as a separate election, the Workers' Party would have won 227 elections throughout the year
#   If the total votes counted throughout the year amounted to an election winner, which party would have won?

National_Party_total = int(elections['National Party'].sum())
Civic_Party_total = int(elections['Civic Party'].sum())
Workers_Party_total = int(elections["Workers' Party"].sum())
Alliance_Party_total = int(elections['Alliance Party'].sum())
Conservative_Party_total = int(elections['Conservative Party'].sum())
Liberal_Party_total = int(elections['Liberal Party'].sum())
Peoples_Party_total = int(elections["People's Party"].sum())

parties = {'National Party': National_Party_total, 'Civic Party': Civic_Party_total, "Workers' Party": Workers_Party_total, 'Alliance Party': Alliance_Party_total, 'Conservative Party': Conservative_Party_total, 'Liberal Party': Liberal_Party_total, "People's Party": Peoples_Party_total}
print(parties)

max_key, max_value = max(parties.items(), key=lambda x: x[1])
print(f"The party with the most votes is the '{max_key}' with a total of {max_value}")
