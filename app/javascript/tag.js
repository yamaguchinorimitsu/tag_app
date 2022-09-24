document.addEventListener("DOMContentLoaded", () => {
  const tagNameInput = document.querySelector("#post_form_tag_name");
    if (tagNameInput){
      //タグのフォームに入力された文字列を取得
      const inputElement = document.getElementById("post_form_tag_name");
      inputElement.addEventListener("input", () => {
      const keyword = document.getElementById("post_form_tag_name").value;
      //XMLHttpRequestオブジェクトを用いてインスタンスを生成し、変数XHRに代入
      const XHR = new XMLHttpRequest();
      //サーチアクションへリクエストする  jsonは、JavaScriptと相性がよい
      XHR.open("GET", `/posts/search/?keyword=${keyword}`, true);
      XHR.responseType = "json";
      //リクエストを送信
      XHR.send();
      //非同期通信後の処理の実装  データの受け取りには、responseプロパティを使用
      //レスポンスの中のkeywordを指定
      XHR.onload = () => {
        const searchResult = document.getElementById("search-result");
        searchResult.innerHTML = "";
        //イフ文を用いて、キャンセルしてもエラーが出ないようにする
        if (XHR.response) {
          const tagName = XHR.response.keyword;
        //①タグを表示させる場所を取得する
          //31行目では、search-resultというid名がついた要素を取得しています。
        //②タグ名を格納するための要素を作成する
          //31行目では、createElementメソッドを用いて、タグを表示させるための要素を生成しています。
          //32行目、33行目では、生成した要素にclassとidを指定しています。
          //34行目では、innerHTMLプロパティを用いて、生成した要素の内容に検索結果のタグ名を指定しています。
        //③作成した要素を表示させる
          //35行目では、appendChildメソッドを用いて、2.で用意した要素を1.の要素に挿入しています。
        //④2.と3.の処理を、検索結果があるだけ繰り返す
          //30行目では、forEachを用いて繰り返し処理を行っています。
        tagName.forEach((tag) => {
          const childElement = document.createElement("div");
          childElement.setAttribute("class", "child");
          childElement.setAttribute("id", tag.id);
          childElement.innerHTML = tag.tag_name;
          searchResult.appendChild(childElement);
         //クリックしたタグがフォームに入力されるようにする
         const clickElement = document.getElementById(tag.id);
          clickElement.addEventListener("click", () => {
            document.getElementById("post_form_tag_name").value = clickElement.textContent;
            clickElement.remove();
          });
        });
        };
      };
    });
    };
  });