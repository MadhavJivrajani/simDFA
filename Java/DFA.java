package Java;
import java.util.*; 
public class DFA{
    Set<String> sigma;
    Dictionary<String, ArrayList<List<String>>> transitions;
    Dictionary<String, State> states;
    int rejected;
    State curr_state;
    int __num_start_states;

    public DFA(Set<String> sigma){
        this.sigma = sigma;
        this.transitions = new Hashtable<String, ArrayList<List<String>>>();
        this.states = new Hashtable<String, State>();
        this.rejected = 0;
        this.curr_state = null;
        this.__num_start_states = 0;

    }

    //I got tired of System.out.println()
    void print(String text){
        System.out.println(text);
    }

    public void add_state(int is_start, int is_final, String name){
        if(this.states.get(name) == null){
            this.states.put(name, new State(is_start,is_final,name));

            if(is_start == 1)
                this.__num_start_states++;
            
            //to ensure that at any point during addition of states, there
            //is at most one start state.
            if(this.__num_start_states > 1)
            print("More than one start state detected but node added");
        }else{
            print("State already exists!");
        }
    }
    public void add_transition(String curr_state, String input_symbol, String next_state){
        if(!this.sigma.contains(input_symbol)){
            print("Input symbol not part of alphabet");
            return;
        }
        if(this.states.get(curr_state) == null){
            print("Current state is not part of the existing set of states");
            return;
        }
        if(this.states.get(next_state) == null){
            print("Next state is not part of the existing set of states");
            return;
        }
        if(this.transitions.get(input_symbol) == null){
            this.transitions.put(input_symbol, new ArrayList<List<String>>());
        }
        List<String> temp = new ArrayList<String>();
        temp.addAll(Arrays.asList(new String[]{curr_state,input_symbol,next_state}));
        ArrayList<List<String>> old_value = this.transitions.get(input_symbol);
        old_value.add(temp); //becomes new value
        this.transitions.put(input_symbol, old_value);
    }

    public State get_start_state(){
        Enumeration<String> enumeration = this.states.keys();
        while(enumeration.hasMoreElements()){
            String ele = enumeration.nextElement();
            if(this.states.get(ele).is_start == 1){
                return this.states.get(ele);
            }
        }
        return null;
    }

    public ArrayList<String> get_final_states(){
        ArrayList<String> final_states = new ArrayList<String>();
        Enumeration<String> enumeration = this.states.keys();
        while(enumeration.hasMoreElements()){
            String ele = enumeration.nextElement();
            if(this.states.get(ele).is_final == 1){
                final_states.add(this.states.get(ele).name);
            }
        }
        return final_states;
    }

    private void apply_transition(String curr_state, String symbol) {
        ArrayList<List<String>> applicable_transitions = new ArrayList<List<String>>();
        Iterator<List<String>> iterator = this.transitions.get(symbol).iterator();
        while(iterator.hasNext()){
            List<String> list = iterator.next();
            if(list.get(0) == curr_state){
                applicable_transitions.add(list);
            }
        }
        if(applicable_transitions.size() > 0){
            this.curr_state = this.states.get(applicable_transitions.get(0).get(2));
        }else{
            this.rejected = 1;
            this.curr_state = this.states.get(curr_state);
        }

    }

    public void evaluate_string(String string){
        if(this.__num_start_states != 1){
            print("More than one start state detected. Exiting");
            return;
        }
        for(int i = 0; i < string.length(); i++){
            if(!this.sigma.contains(Character.toString(string.charAt(i)))){
                print("'"+string.charAt(i)+"' is not part of the alphabet");
                return;
            }
        }
        this.rejected = 0;
        State start_state = this.get_start_state();
        ArrayList<String> final_states = this.get_final_states();

        this.curr_state = start_state;
        for(int i = 0; i < string.length(); i++){
            if(this.rejected == 0){
                this.apply_transition(this.curr_state.name, Character.toString(string.charAt(i)));
            }else{
                print("Rejected");
                return;
            }
        }
        if(final_states.contains(this.curr_state.name)){
            print("Accepted!");
            
        }else{
            print("Rejected");
        }
    }

    public static void main(String[] args) {
        //System.out.println("Hello World");
        Set<String> alphabet = new HashSet<String>();
        alphabet.addAll(Arrays.asList(new String[]{"a","b"}));
        DFA dfa = new DFA(alphabet);
        dfa.add_state(1, 1, "q0");
        dfa.add_state(0, 1, "q1");
        dfa.add_state(0, 1, "q2");
        dfa.add_state(0, 1, "q3");
        dfa.add_state(0, 0, "q4");

        dfa.add_transition("q0", "a", "q1");
        dfa.add_transition("q0", "b", "q0");
        dfa.add_transition("q1", "a", "q2");
        dfa.add_transition("q1", "b", "q1");
        dfa.add_transition("q2", "a", "q3");
        dfa.add_transition("q2", "b", "q2");
        dfa.add_transition("q3", "a", "q4");
        dfa.add_transition("q3", "b", "q3");
        dfa.add_transition("q4", "a", "q4");
        dfa.add_transition("q4", "b", "q4");

        dfa.evaluate_string("aaab");  //Accepted!
        dfa.evaluate_string("aaaab"); //Rejected
        dfa.evaluate_string("");	//Accepted!
        dfa.evaluate_string("bbbb");  //Accepted!
    }
}