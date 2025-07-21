import { QuartzComponent, QuartzComponentConstructor, QuartzComponentProps } from "./types"
import Explorer, { Options as ExplorerOptions } from "./Explorer"
import { i18n } from "../i18n"
import { classNames } from "../util/lang"
import style from "./styles/sectionExplorer.scss"

export interface SectionAwareExplorerOptions extends Partial<ExplorerOptions> {
  showOnlyInSections?: string[]
  showBasicNavigation?: boolean
}

const defaultOptions: SectionAwareExplorerOptions = {
  showOnlyInSections: ["notes", "posts"],
  showBasicNavigation: true,
  folderDefaultState: "collapsed",
  folderClickBehavior: "link",
  useSavedState: true,
}

export default ((userOpts?: SectionAwareExplorerOptions) => {
  const opts = { ...defaultOptions, ...userOpts }
  
  const SectionAwareExplorer: QuartzComponent = ({ fileData, displayClass, ...props }: QuartzComponentProps) => {
    // This component only shows basic navigation for non-section pages
    return (
      <div class={classNames(displayClass, "section-explorer")}>
        <h3>Sections</h3>
        <ul class="section-ul">
          <li>
            <a href="/about" class="internal">
              About
            </a>
          </li>
          <li>
            <a href="/notes" class="internal">
              Notes
            </a>
          </li>
          <li>
            <a href="/posts" class="internal">
              Posts
            </a>
          </li>
        </ul>
      </div>
    )
  }

  SectionAwareExplorer.css = style
  
  return SectionAwareExplorer
}) satisfies QuartzComponentConstructor