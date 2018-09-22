# Can you trust your gut? A probabilistic approach
# Monty Hall Problem
# Let's make a deal -- Monty hall
# Contestants were asked to pick one out of three doors
# behind one of the doors, it was a prize, and behind others
# a goat, so it was asked which of the doors the contestant want
# and then it showed that behind one of the doors that the contestant
# didn't choose there was a goat. And then he asked, so 
# do you want to change doors? Based on that, is in the best
# interest of the contestant switch doors? 
library(dplyr)
library(ggplot2)
library(ggthemes)
simulation_attempts <- 10000
monty_hall <- function(attempts,I_switch=FALSE){
  replicate(attempts,{ 
    doors <- as.character(seq(1,3))
    prize <- sample(c("house","goat","goat"))
    door_with_prize <- doors[prize %in% "house"]
    i_choose <- sample(doors,1)
    my_and_prize_door <- doors %in% c(i_choose,door_with_prize)
    what_door_to_show <- sample(doors[!my_and_prize_door],1)
    choice_that_have_left <- !doors%in%c(i_choose,what_door_to_show)
    if(I_switch) {
      final_say <- doors[choice_that_have_left]
    }
    else final_say <- i_choose
    final_say
    final_say == door_with_prize
  }) 
}
trusted_my_gut <- mean(monty_hall(simulation_attempts))*100
switched <- mean(monty_hall(simulation_attempts,I_switch=TRUE))*100

monty_hall_experiment=data.frame(name=c("Trusted my gut","Switched"),
                                 probability=c(trusted_my_gut,switched))
monty_hall_experiment %>% ggplot(aes(x=name, y=probability,label=probability,fill=probability)) + 
  geom_bar(stat = "identity") + geom_text(vjust=2,color='white') + 
  ylim(0,100) + ylab('Probability of winning') + xlab('') + 
  ggtitle('Monty Hall Experiment') +theme_economist()

the_10_cards_experiment <- function(attempts,I_switch=FALSE){
  replicate(attempts,{ 
    cards <- seq(1,10)
    prize <- sample(cards,1)
    i_choose <- sample(cards,1)
    my_card_and_prize <- cards %in% c(i_choose,prize)
    what_cards_to_show <- sample(cards[!my_card_and_prize],8)
    choice_that_have_left <- !cards%in%c(i_choose,what_cards_to_show)
    if(I_switch) {
      final_say <- cards[choice_that_have_left]
    }
    else final_say <- i_choose
    final_say == prize
  }) 
}
trusted_my_gut <- mean(the_10_cards_experiment(simulation_attempts))*100
switched <- mean(the_10_cards_experiment(simulation_attempts,I_switch=TRUE))*100

monty_hall_experiment=data.frame(name=c("Trusted my gut","Switched"),
                                 probability=c(trusted_my_gut,switched))
monty_hall_experiment %>% ggplot(aes(x=name, y=probability,label=probability,fill=probability)) + 
  geom_bar(stat = "identity") + geom_text(vjust=1.3,color='white') + 
  ylim(0,100) + ylab('Probability of winning') + xlab('') + 
  ggtitle('The 10 Cards Experiment') +theme_economist()

# Let's go nuts and plot a graph of the number of cards 
# and the probability of winning a certain game,
# Here's the experiment in place I will show you all of the cards 
# except one, and let's test what is the probability of winning 
# from 3 cards up to 100

the_n_cards_experiment <- function(attempts,number_of_cards,I_switch=FALSE){
  replicate(attempts,{ 
    cards <- seq(1,number_of_cards)
    prize <- sample(cards,1)
    i_choose <- sample(cards,1)
    my_card_and_prize <- cards %in% c(i_choose,prize)
    what_cards_to_show <- cards[!my_card_and_prize]
    if(length(what_cards_to_show) > 1){
      what_cards_to_show <- sample(what_cards_to_show,number_of_cards-2)
    }
    choice_that_have_left <- !cards%in%c(i_choose,what_cards_to_show)
    if(I_switch) {
      final_say <- cards[choice_that_have_left]
    } 
    else final_say <- i_choose
    final_say == prize
  }) 
}
number_of_cards <- seq(3,100)
trusted_my_gut <- c()
switched <- c()
aux <- 1
for(counter in number_of_cards){
  trusted_my_gut[aux] <- mean(the_n_cards_experiment(10000,counter))*100
  aux <- aux + 1
}
aux <- 1
for(counter in number_of_cards){
  switched[aux] <- mean(the_n_cards_experiment(10000,counter,I_switch=TRUE))*100
  aux <- aux + 1
}

n_cards_experiment=data.frame(number=number_of_cards,trusted=trusted_my_gut,
                              switched=switched)
n_cards_experiment %>% ggplot(aes(x=n_cards_experiment$number)) +
  geom_point(y=n_cards_experiment$switched,alpha=.5,stat='identity') +
  ylim(0,100) + ylab('aa of winning') + xlab('a') + 
  ggtitle('The N Cards Experiment') + theme_fivethirtyeight()
