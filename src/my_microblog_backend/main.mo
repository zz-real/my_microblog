import List "mo:base/List";
import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Time "mo:base/Time";

actor {

  public type Message = {
    text :Text;
    time :Time.Time;
  };

  stable var followed :List.List<Principal> = List.nil();

  stable var messages :List.List<Message> = List.nil();

  

  public type Microblog = actor {
      follow: shared(Principal)  -> async (); //添加关注对象
      follows: shared query ()  -> async [Principal]; //返回关注对象列表
      post: shared (Text)  -> async (); //发布新消息
      posts: shared query (Time.Time)  -> async [Message]; //返回所有发布的消息
      timeline: shared (Time.Time)  -> async [Message]; //返回所有关注对象发布的消息
  };


  public shared func follow (id :Principal) :async(){
      followed := List.push(id, followed);
  };

  public shared query func follows () :async [Principal]{
      List.toArray(followed);
  };

  public shared (caller) func post (text :Text) :async (){
      assert(Principal.toText(caller.caller)) == "2n7zy-fkbbu-hbeqh-nnmis-7his4-tolog-xakb3-vucas-tlhix-7m55o-qqe";

      var msg : Message = {
            text = text;
            time = Time.now();
        };

      messages := List.push(msg, messages);
  };
  
  public shared query func posts(since : Time.Time) :async [Message]{
      var since_message : List.List<Message> = List.nil();
        for (msg in Iter.fromList(messages)) {
            if (msg.time >= since) {
                since_message := List.push(msg, since_message);
            };
        };
      return List.toArray(since_message);
  };

  public shared func timeline(since : Time.Time) : async [Message]{
      var all :List.List<Message> = List.nil();

      for (id in Iter.fromList(followed)){
          let canister :Microblog = actor(Principal.toText(id));
          let msgs = await canister.posts(since);
          for(msg in Iter.fromArray(msgs)){
               all := List.push(msg, all);
          };
      };

      List.toArray(all);
  };
};
