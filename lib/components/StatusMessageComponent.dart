/*
 * Copyright (c) 2016, Michael Mitterer (office@mikemitterer.at),
 * IT-Consulting and Development Limited.
 * 
 * All Rights Reserved.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
     
part of spaceinvaders.components;

/* 
/// Basic DI configuration for [StatusMessageComponent]
///
/// Usage:
///     class MainModule extends di.Module {
///         MainModule() {
///             install(new StatusMessageComponentModule());
///         }     
///     }
class StatusMessageComponentModule  extends di.Module {
    StatusMessageComponentModule() {
        // bind(DeviceProxy);
        
        // -- services
        // bind(SignalService, toImplementation: SignalServiceImpl);
    }
} 
*/

/// Controller-View for <mdlx-status-message></mdlx-status-message>
///
@Component
class StatusMessageComponent extends MdlComponent {
    final Logger _logger = new Logger('spaceinvaders.components.StatusMessageComponent');

    //static const _StatusMessageComponentConstant _constant = const _StatusMessageComponentConstant();
    static const _StatusMessageComponentCssClasses _cssClasses = const _StatusMessageComponentCssClasses();
    
    /// Change this to a more specific version
    final SpaceInvadersStore _store;
    
    StatusMessageComponent.fromElement(final dom.HtmlElement element,final di.Injector injector)
        : _store = injector.get(SpaceInvadersStore), super(element,injector) {
        
        _init();
        
    }
    
    static StatusMessageComponent widget(final dom.HtmlElement element) => mdlComponent(element,StatusMessageComponent) as StatusMessageComponent;
    
    // - EventHandler -----------------------------------------------------------------------------

    //- private -----------------------------------------------------------------------------------

    void _init() {
        _logger.info("StatusMessageComponent - init");
        
        // Recommended - add SELECTOR as class if this component is a TAG!
        element.classes.add(_StatusMessageComponentConstant.WIDGET_SELECTOR);

        _bindStoreActions();

        element.classes.add(_cssClasses.IS_UPGRADED);
    }
    
    /// After the template is rendered we bind all the necessary Actions for this component
    void _bindStoreActions() {
        // only after creation...
        if(_store == null) { return;}

        _store.onChange.listen((final DataStoreChangedEvent event) {

            // Handle specific Update-Actions
            // if(event.data.actionname == UpdateTimeView.NAME) {
            //
            // }

            _updateView();

        });
    }

    /// Something has changed in the attached store - visualize it
    ///
    /// Usually this function is called if we get an onChange-event from our store
    void _updateView() {
        switch(_store.gamestate) {
            case GameState.YouWon:
                _headline?.text = "Game over";
                _subheadline?.text = "You won!!!";
                break;
            case GameState.YouLost:
                _headline?.text = "Game over";
                _subheadline?.text = "You lost!";
                break;
            default:
                _headline?.text = "Have Fun";
                _subheadline?.text = "with Dart-Invaders";
        }
    }

    dom.HtmlElement get _headline => element.querySelector(".${_cssClasses.HEADLINE}");
    dom.HtmlElement get _subheadline => element.querySelector(".${_cssClasses.SUBHEADLINE}");
}

/// Registers the StatusMessageComponent-Component
///
///     main() {
///         registerStatusMessageComponent();
///         ...
///     }
///
void registerStatusMessageComponent() {
    final MdlConfig config = new MdlWidgetConfig<StatusMessageComponent>(
        _StatusMessageComponentConstant.WIDGET_SELECTOR,
            (final dom.HtmlElement element,final di.Injector injector) => new StatusMessageComponent.fromElement(element,injector)
    );
    
    // If you want <mdlx-status-message></mdlx-status-message> set selectorType to SelectorType.TAG.
    // If you want <div mdlx-status-message></div> set selectorType to SelectorType.ATTRIBUTE.
    // By default it's used as a class name. (<div class="mdlx-status-message"></div>)
    config.selectorType = SelectorType.TAG;
    
    componentHandler().register(config);
}

//- private Classes ----------------------------------------------------------------------------------------------------

/// Store strings for class names defined by this component that are used in
/// Dart. This allows us to simply change it in one place should we
/// decide to modify at a later date.
class _StatusMessageComponentCssClasses {

    final String HEADLINE = "${_StatusMessageComponentConstant.WIDGET_SELECTOR}__headline";
    final String SUBHEADLINE = "${_StatusMessageComponentConstant.WIDGET_SELECTOR}__subheadline";

    final String IS_UPGRADED = 'is-upgraded';
    
    const _StatusMessageComponentCssClasses(); }
    
/// Store constants in one place so they can be updated easily.
class _StatusMessageComponentConstant {

    static const String WIDGET_SELECTOR = "mdlx-status-message";

    const _StatusMessageComponentConstant();
}  