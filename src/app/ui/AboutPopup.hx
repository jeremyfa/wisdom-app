package app.ui;

import kit.Binding;
import wisdom.Component;

/** What this is, where it runs, and the shortcuts it answers to. */
class AboutPopup extends Component {

    function render() '<>
        <Popup title="About" onClose=${() -> model.ui.popup = null}>
            <div class="flex flex-col gap-4">

                <div>
                    <div class="text-[15px] font-semibold">Wisdom App</div>
                    <div class="text-[12.5px] text-t-text-muted mono">
                        v${App.VERSION} · ${Platform.isDesktop() ? 'desktop' : 'web'}
                    </div>
                </div>

                <p class="m-0 text-[13px] leading-relaxed text-t-text-muted">
                    A starter kit for Haxe applications rendered with wisdom, kept reactive
                    with tracker and styled with Tailwind. The same build runs as a web page
                    and as a desktop app.
                </p>

                <div>
                    <SectionHeader label="Shortcuts" />
                    <div class="mt-1.5 flex flex-col gap-1">
                        // Keys.all rather than this table alone: the shell
                        // contributes the zoom shortcuts, and leaving them out
                        // would make them look like undocumented magic.
                        <foreach ${Keys.all} ${(_:Int, binding:Binding) -> '<>
                            <div key=${binding.key} class="flex items-center justify-between gap-4 text-[12.5px]">
                                <span class="text-t-text-muted">${binding.description}</span>
                                <span class="mono text-t-text-faint">${Keys.label(binding)}</span>
                            </div>
                        '} />
                    </div>
                </div>

                <Button icon="external-link" label="Lucide icons"
                        onpress=${() -> Platform.openUrl('https://lucide.dev', _ -> {})} />

            </div>
        </Popup>
    ';

}
