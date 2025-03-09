:- discontiguous love_attributes/2.
:- dynamic love_attributes/2.
:- discontiguous total_love_score/2.
:- discontiguous best_love/1.

% Define love attributes for each person 
love_attributes(melthida, [
    sacrifice(7), patience(9), devotion(10), loyalty(8), kindness(8),
    understanding(7), communication(7), trust(8), support(9), empathy(8)
]).

love_attributes(yar_ma, [
    sacrifice(9), patience(8), devotion(9), loyalty(8), kindness(9),
    understanding(8), communication(7), trust(9), support(7), empathy(8)
]).

love_attributes(dektha_ghiri, [
    sacrifice(7), patience(10), devotion(10), loyalty(7), kindness(7),
    understanding(7), communication(7), trust(7), support(8), empathy(7)
]).

% Calculate total love score by summing attribute values
sum_attributes([], 0).
sum_attributes([AttrValue | Rest], TotalScore) :-
    AttrValue =.. [_Attr, Value],  % Extract numeric value
    sum_attributes(Rest, RestScore),
    TotalScore is Value + RestScore.

% Get total love score for a person
total_love_score(Person, Score) :-
    love_attributes(Person, Attributes),
    sum_attributes(Attributes, Score).

% Find the person with the highest love score
max_score_person([], BestPerson, _, BestPerson).  % Base case: return the best found
max_score_person([Person | Rest], CurrentBest, MaxScore, BestPerson) :-
    total_love_score(Person, Score),
    ( Score > MaxScore ->
        max_score_person(Rest, Person, Score, BestPerson)
    ; max_score_person(Rest, CurrentBest, MaxScore, BestPerson)
    ).

% Determine who has the best love
best_love(BestPerson) :-
    findall(Person, love_attributes(Person, _), Persons),  % Get all candidates
    Persons = [First | Rest],   % Ensure the list isn't empty
    total_love_score(First, FirstScore),
    max_score_person(Rest, First, FirstScore, BestPerson).

% Prompt for and update love attributes
prompt_love_attributes(Person) :-
    write('Enter love attributes for '), write(Person), nl,
    prompt_attribute(sacrifice, Score1),
    prompt_attribute(patience, Score2),
    prompt_attribute(devotion, Score3),
    prompt_attribute(loyalty, Score4),
    prompt_attribute(kindness, Score5),
    prompt_attribute(understanding, Score6),
    prompt_attribute(communication, Score7),
    prompt_attribute(trust, Score8),
    prompt_attribute(support, Score9),
    prompt_attribute(empathy, Score10),
    retract(love_attributes(Person, _)), % Remove old attributes
    assertz(love_attributes(Person, [
        sacrifice(Score1), patience(Score2), devotion(Score3), 
        loyalty(Score4), kindness(Score5), understanding(Score6),
        communication(Score7), trust(Score8), support(Score9), 
        empathy(Score10)
    ])),
    write('Love attributes updated for '), write(Person), nl.

% Helper predicate to prompt for a single attribute
prompt_attribute(Attribute, Score) :-
    write('Enter score for '), write(Attribute), 
    write(' (1-10): '),
    read(Score),
    Score >= 1,
    Score =< 10.

% Update attributes for all members
update_all_members :-
    findall(Person, love_attributes(Person, _), Persons),
    update_members(Persons).

update_members([]).
update_members([Person|Rest]) :-
    prompt_love_attributes(Person),
    update_members(Rest).
