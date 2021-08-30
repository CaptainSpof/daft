use std::path::PathBuf;

use random_ramble::refactor::RandomRamble;
use yew::prelude::*;

enum Msg {
    AddOne,
    NewRand
}

struct Model {
    // `ComponentLink` is like a reference to a component.
    // It can be used to send messages to the component
    link: ComponentLink<Self>,
    value: i64,
    rr: String,
}

impl Component for Model {
    type Message = Msg;
    type Properties = ();

    fn create(_props: Self::Properties, link: ComponentLink<Self>) -> Self {

        let mut adjs_path = PathBuf::from("./adj");
        let mut themes_path = PathBuf::from("./theme");

        let rr = RandomRamble::default()
            .with_themes_path(&themes_path).expect("shit")
            .with_adjs_path(&adjs_path).expect("merde");
        let rr = "ertua";

        Self {
            link,
            value: 0,
            rr: rr.to_string()
        }
    }

    fn update(&mut self, msg: Self::Message) -> ShouldRender {
        let mut adjs_path = PathBuf::from("./adj");
        let mut themes_path = PathBuf::from("./theme");

        let rr = RandomRamble::default()
                    // .with_themes(vec!["Tom", "Jerry"])
                    // .with_adjs(vec!["Fast", "Angry", "Stupid"]);
            .with_themes_path(&themes_path).expect("shit")
            .with_adjs_path(&adjs_path).expect("merde");
        match msg {
            Msg::AddOne => {
                self.value += 1;
                // the value has changed so we need to
                // re-render for it to appear on the page
                true
            },
            Msg::NewRand => {
                self.rr = rr.to_string();
                // the value has changed so we need to
                // re-render for it to appear on the page
                true
            }
        }
    }

    fn change(&mut self, _props: Self::Properties) -> ShouldRender {
        // Should only return "true" if new properties are different to
        // previously received properties.
        // This component has no properties so we will always return "false".
        false
    }

    fn view(&self) -> Html {
        html! {
            <div>
                <button onclick=self.link.callback(|_| Msg::NewRand)>{ "Randomize" }</button>
                <p>{ self.value }</p>
                <p>{ self.rr.clone() }</p>
            </div>
        }
    }
}

fn main() {
    yew::start_app::<Model>();
}
