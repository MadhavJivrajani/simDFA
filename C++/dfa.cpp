#include <bits/stdc++.h>
#include "dfa.hpp"

using namespace std;

int present_in(vector<string> alphabet, string s) {
  if(find(alphabet.begin(), alphabet.end(), s) != alphabet.end()) return 1;
  else return 0;
}

State::State(bool s_start, bool s_final, string s_name)
  : is_start(s_start), is_final(s_final), name(s_name) {}

DFA::DFA(vector<string> alphabet)
  : sigma(alphabet), rejected(0), curr_state(nullptr) {}


void DFA::add_state(bool is_start, bool is_final, string name) {
  if(states.find(name) == states.end()) {
    State *state = new State(is_start, is_final, name);
    states[name] = state;
  } else {
    cout << "State already exists!";
  }

}

void DFA::add_transition(string curr_state, string input_symbol, string next_state) {
  if(!present_in(sigma, input_symbol)) {
    cout << "Input symbol not part of the alphabet";
    return;
  }

  if(states.find(curr_state) == states.end()) {
    cout << "Current state is not part of the existing set of states";
    return;
  }

  if(states.find(next_state) == states.end()) {
    cout << "Next state is not part of the existing set of states";
    return;
  }

  if(transitions.find(input_symbol) == transitions.end()) {
    transitions[input_symbol] = vector<tuple<string, string, string>> ();
  }

  transitions[input_symbol].push_back(make_tuple(curr_state, input_symbol, next_state));
}

State* DFA::get_start_state() {
  for(auto i : states) {
    if((i.second)->is_start == true) return i.second;
  }
}

vector<string> DFA::get_final_states() {
  vector<string> final_s;

  for(auto i : states) {
    if((i.second)->is_final == true) final_s.push_back(i.second->name);
  }
  return final_s;
}

void DFA::apply_transition(vector<string> partial_transition) {
  string symbol = partial_transition[1];
  string current = partial_transition[0];
  
  vector<tuple<string, string, string>> total;
  total = transitions[symbol];
  vector<tuple<string, string, string>> applicable;

  for(int i = 0;i < total.size(); i++) {
    if(get<0>(total[i]) == current) applicable.push_back(total[i]);
  }

  if(applicable.size()) {
    curr_state = states[get<2>(applicable[0])];
  } else {
    rejected = 1;
    curr_state = states[current];
  }
}

void DFA::evaluate_string(string str) {
  for(int i = 0; i < str.length(); i++) {
    string symb(1, str[i]);
    if(!present_in(sigma, symb)) {
      cout << str[i] << " is not part of the alphabet\n";
      return;
    }
  }

  rejected = 0;
  State* start = get_start_state();
  vector<string> final_states;
  final_states = get_final_states();

  curr_state = start;

  for(int i = 0; i < str.length(); i++) {
    if(rejected == 0) {
      string symb(1, str[i]);
      vector<string> partial = {curr_state->name, symb};
      apply_transition(partial);
    } else {
      cout << "Rejected\n";
      return;
    }
  }

  if(find(final_states.begin(), final_states.end(), curr_state->name) != final_states.end())
    cout << "Accepted!\n";

  else
    cout << "Rejected\n";
}
