
# code

actor {
  public type Message = Text;

  public type Microblog = actor {
      follow: shared(Principal)  -> async (); //添加关注对象
      follows: shared query ()  -> async [Principal]; //返回关注对象列表
      post: shared (Text)  -> async (); //发布新消息
      posts: shared query ()  -> async [Message]; //返回所有发布的消息
      timeline: shared ()  -> async [Message]; //返回所有关注对象发布的消息
  };

  stable var followed :List.List<Principal> = List.nil();

  public shared func follow (id :Principal) :async(){
      followed := List.push(id, followed);
  };

  public shared query func follows () :async [Principal]{
      List.toArray(followed);
  };

  stable var messages :List.List<Message> = List.nil();

  public shared (msg) func post (text :Text) :async (){
      assert(Principal.toText(msg.caller)) == "2n7zy-fkbbu-hbeqh-nnmis-7his4-tolog-xakb3-vucas-tlhix-7m55o-qqe";
      messages := List.push(text, messages);
  };
  
  public shared query func posts() :async [Message]{
      List.toArray(messages);
  };

  public shared func timeline() : async [Message]{
      var all :List.List<Message> = List.nil();

      for (id in Iter.fromList(followed)){
          let canister :Microblog = actor(Principal.toText(id));
          let msgs = await canister.posts();
          for(msg in Iter.fromArray(msgs)){
              all := List.push(msg, all);
          };
      };

      List.toArray(all);
  };
};

# 控制台输出

# root@win10-zz:/my_microblog# dfx deploy
Deploying all canisters.
All canisters have already been created.
Building canisters...
Installing canisters...
Creating UI canister on the local network.
The UI canister on the "local" network is "r7inp-6aaaa-aaaaa-aaabq-cai"
Installing code for canister my_microblog_backend, with canister ID rrkah-fqaaa-aaaaa-aaaaq-cai
Installing code for canister my_microblog_frontend, with canister ID ryjl3-tyaaa-aaaaa-aaaba-cai
Uploading assets to asset canister...
Starting batch.
Staging contents of new and changed assets:
  /sample-asset.txt 1/1 (24 bytes)
Committing batch.
Deployed canisters.
URLs:
  Backend canister via Candid interface:
    my_microblog_backend: http://127.0.0.1:8000/?canisterId=r7inp-6aaaa-aaaaa-aaabq-cai&id=rrkah-fqaaa-aaaaa-aaaaq-cai
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend post '("First post")'
()
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend posts '()'
(vec { "First post" })
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend post '("Second post")'
()
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend posts '()'
(vec { "Second post"; "First post" })
# root@win10-zz:/my_microblog# dfx deploy
Deploying all canisters.
Creating canisters...
Creating canister my_microblog_backend2...
my_microblog_backend2 canister created with canister id: rkp4c-7iaaa-aaaaa-aaaca-cai
Building canisters...
Installing canisters...
Module hash 0e20885e2ff33c84b1326967d5a373a3a92b9b8679a4f0fdbc97d62dd8fb3989 is already installed.
Installing code for canister my_microblog_backend2, with canister ID rkp4c-7iaaa-aaaaa-aaaca-cai
Module hash 183df2eb0f1846054e26e3ed17308c65dd0c7af079cd8896406dd959691004bb is already installed.
Uploading assets to asset canister...
Starting batch.
Staging contents of new and changed assets:
  /sample-asset.txt (24 bytes) sha 2d523f5aaeb195da24dcff49b0d560a3d61b8af859cee78f4cff0428963929e6 is already installed
Committing batch.
Deployed canisters.
URLs:
  Backend canister via Candid interface:
    my_microblog_backend: http://127.0.0.1:8000/?canisterId=r7inp-6aaaa-aaaaa-aaabq-cai&id=rrkah-fqaaa-aaaaa-aaaaq-cai
    my_microblog_backend2: http://127.0.0.1:8000/?canisterId=r7inp-6aaaa-aaaaa-aaabq-cai&id=rkp4c-7iaaa-aaaaa-aaaca-cai
# root@win10-zz:/my_microblog# dfx canister id my_microblog_backend
rrkah-fqaaa-aaaaa-aaaaq-cai
# root@win10-zz:/my_microblog# dfx canister id my_microblog_backend2
rkp4c-7iaaa-aaaaa-aaaca-cai
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend2 follow "(principal \"$(dfx canister id my_microblog_backend)\")"
()
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend2 follows "()"
(vec { principal "rrkah-fqaaa-aaaaa-aaaaq-cai" })
# root@win10-zz:/my_microblog# dfx identity get-principal
2n7zy-fkbbu-hbeqh-nnmis-7his4-tolog-xakb3-vucas-tlhix-7m55o-qqe
# root@win10-zz:/my_microblog# dfx deploy
Deploying all canisters.
All canisters have already been created.
Building canisters...
Installing canisters...
Upgrading code for canister my_microblog_backend, with canister ID rrkah-fqaaa-aaaaa-aaaaq-cai
Upgrading code for canister my_microblog_backend2, with canister ID rkp4c-7iaaa-aaaaa-aaaca-cai
Module hash 183df2eb0f1846054e26e3ed17308c65dd0c7af079cd8896406dd959691004bb is already installed.
Uploading assets to asset canister...
Starting batch.
Staging contents of new and changed assets:
  /sample-asset.txt (24 bytes) sha 2d523f5aaeb195da24dcff49b0d560a3d61b8af859cee78f4cff0428963929e6 is already installed
Committing batch.
Deployed canisters.
URLs:
  Backend canister via Candid interface:
    my_microblog_backend: http://127.0.0.1:8000/?canisterId=r7inp-6aaaa-aaaaa-aaabq-cai&id=rrkah-fqaaa-aaaaa-aaaaq-cai
    my_microblog_backend2: http://127.0.0.1:8000/?canisterId=r7inp-6aaaa-aaaaa-aaabq-cai&id=rkp4c-7iaaa-aaaaa-aaaca-cai
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend2 follows "()"
(vec {})
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend2 follow "(principal \"$(dfx canister id my_microblog_backend)\")"
()
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend2 follows "()"
(vec { principal "rrkah-fqaaa-aaaaa-aaaaq-cai" })
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend post '("First post")'
()
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend post '("Second post")'
()
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend posts '()'
(vec { "Second post"; "First post" })
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend2 timeline '()'
(vec { "First post"; "Second post" })
# root@win10-zz:/my_microblog# dfx canister --wallet=$(dfx identity get-wallet) call my_microblog_backend post '("Second post")'
Error: Failet to do wallet call.
Caused by: Failet to do wallet call.
  An error happened during the call: 5: IC0503: Canister rrkah-fqaaa-aaaaa-aaaaq-cai trapped explicitly: assertion failed at main.mo:29.7-29.112
# root@win10-zz:/my_microblog# 

# root@win10-zz:/my_microblog# dfx deploy
Deploying all canisters.
All canisters have already been created.
Building canisters...
Installing canisters...
Module hash 2450bc0dc2d455b78bbdc1738c7bbb25927a59ca6c2a981b9ed98719846580d3 is already installed.
Module hash 2450bc0dc2d455b78bbdc1738c7bbb25927a59ca6c2a981b9ed98719846580d3 is already installed.
Module hash 183df2eb0f1846054e26e3ed17308c65dd0c7af079cd8896406dd959691004bb is already installed.
Uploading assets to asset canister...
Starting batch.
Staging contents of new and changed assets:
  /sample-asset.txt (24 bytes) sha 2d523f5aaeb195da24dcff49b0d560a3d61b8af859cee78f4cff0428963929e6 is already installed
Committing batch.
Deployed canisters.
URLs:
  Backend canister via Candid interface:
    my_microblog_backend: http://127.0.0.1:8000/?canisterId=r7inp-6aaaa-aaaaa-aaabq-cai&id=rrkah-fqaaa-aaaaa-aaaaq-cai
    my_microblog_backend2: http://127.0.0.1:8000/?canisterId=r7inp-6aaaa-aaaaa-aaabq-cai&id=rkp4c-7iaaa-aaaaa-aaaca-cai

# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend post '("First post")'
()
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend post '("Second post")'
()
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend posts '(1663485317211)'
(
  vec {
    record { "text" = "First post"; time = 1_663_484_992_996_352_300 : int };
    record { "text" = "Second post"; time = 1_663_484_999_857_307_200 : int };
  },
)
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend posts '(1663485317211000000)'
(vec {})
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend posts '(1663483317211000000)'
(
  vec {
    record { "text" = "First post"; time = 1_663_484_992_996_352_300 : int };
    record { "text" = "Second post"; time = 1_663_484_999_857_307_200 : int };
  },
)
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend2 timeline '(1663483317211000000)'
(
  vec {
    record { "text" = "Second post"; time = 1_663_484_999_857_307_200 : int };
    record { "text" = "First post"; time = 1_663_484_992_996_352_300 : int };
  },
)
# root@win10-zz:/my_microblog# dfx canister call my_microblog_backend2 timeline '(1663485317211000000)'
(vec {})
root@win10-zz:/my_microblog# 