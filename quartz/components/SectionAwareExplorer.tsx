import { QuartzComponent, QuartzComponentConstructor, QuartzComponentProps } from "./types"
import Explorer, { Options as ExplorerOptions } from "./Explorer"
import { i18n } from "../i18n"
import { classNames } from "../util/lang"

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
  
  const SectionAwareExplorer: QuartzComponent = ({ fileData, ...props }: QuartzComponentProps) => {
    // This component only shows basic navigation for non-section pages
    return (
      <div class={classNames(props.displayClass, "section-nav")}>
        <h3>Sections</h3>
        <ul class="section-list">
          <li>
            <a href="/about" class="internal section-link">
              About
            </a>
          </li>
          <li>
            <a href="/notes" class="internal section-link">
              Notes
            </a>
          </li>
          <li>
            <a href="/posts" class="internal section-link">
              Posts
            </a>
          </li>
        </ul>
      </div>
    )
  }

  SectionAwareExplorer.css = `
.section-nav {
  display: flex;
  flex-direction: column;
  min-height: 1.2rem;
}

.section-nav h3 {
  font-size: 1rem;
  margin: 0 0 0.5rem 0;
  color: var(--darkgray);
}

.section-list {
  list-style: none;
  margin: 0;
  padding: 0;
}

.section-list li {
  margin: 0.25rem 0;
}

.section-link {
  color: var(--dark);
  text-decoration: none;
  padding: 0.25rem 0.5rem;
  border-radius: 5px;
  display: block;
  transition: background-color 0.2s ease;
}

.section-link:hover {
  background-color: var(--lightgray);
}
`
  
  return SectionAwareExplorer
}) satisfies QuartzComponentConstructor