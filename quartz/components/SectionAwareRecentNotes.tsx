import { QuartzComponent, QuartzComponentConstructor, QuartzComponentProps } from "./types"
import { FullSlug, SimpleSlug, resolveRelative } from "../util/path"
import { QuartzPluginData } from "../plugins/vfile"
import { byDateAndAlphabetical } from "./PageList"
import style from "./styles/recentNotes.scss"
import { Date, getDate } from "./Date"
import { GlobalConfiguration } from "../cfg"
import { i18n } from "../i18n"
import { classNames } from "../util/lang"

interface SectionAwareRecentNotesOptions {
  title?: string
  limit: number
  linkToMore: SimpleSlug | false
  showTags: boolean
  filter: (f: QuartzPluginData) => boolean
  sort: (f1: QuartzPluginData, f2: QuartzPluginData) => number
  showForSections?: string[]
  sectionSpecificTitles?: Record<string, string>
}

const defaultOptions = (cfg: GlobalConfiguration): SectionAwareRecentNotesOptions => ({
  limit: 5,
  linkToMore: false,
  showTags: true,
  filter: () => true,
  sort: byDateAndAlphabetical(cfg),
  showForSections: ["notes", "posts", "index"],
  sectionSpecificTitles: {
    notes: "Recent Notes",
    posts: "Recent Posts",
    index: "Recent Updates"
  }
})

export default ((userOpts?: Partial<SectionAwareRecentNotesOptions>) => {
  const SectionAwareRecentNotes: QuartzComponent = ({
    allFiles,
    fileData,
    displayClass,
    cfg,
  }: QuartzComponentProps) => {
    const opts = { ...defaultOptions(cfg), ...userOpts }
    
    // Get the current section from the slug
    const currentSlug = fileData.slug || ""
    const pathSegments = currentSlug.split("/").filter(Boolean)
    const currentSection = pathSegments[0] || "index"
    
    // Check if we should show recent notes for this section
    if (!opts.showForSections?.includes(currentSection)) {
      return null
    }
    
    // Filter files by section
    let filteredPages = allFiles.filter(opts.filter)
    
    if (currentSection === "notes") {
      filteredPages = filteredPages.filter(page => page.slug?.startsWith("notes/"))
    } else if (currentSection === "posts") {
      filteredPages = filteredPages.filter(page => page.slug?.startsWith("posts/"))
    }
    // For index page, show all files
    
    const pages = filteredPages.sort(opts.sort)
    const remaining = Math.max(0, pages.length - opts.limit)
    
    // Get section-specific title
    const sectionTitle = opts.sectionSpecificTitles?.[currentSection] || 
                        opts.title || 
                        i18n(cfg.locale).components.recentNotes.title
    
    return (
      <div class={classNames(displayClass, "recent-notes", `recent-notes-${currentSection}`)}>
        <h3>{sectionTitle}</h3>
        <ul class="recent-ul">
          {pages.slice(0, opts.limit).map((page) => {
            const title = page.frontmatter?.title ?? i18n(cfg.locale).propertyDefaults.title
            const tags = page.frontmatter?.tags ?? []

            return (
              <li class="recent-li">
                <div class="section">
                  <div class="desc">
                    <h3>
                      <a href={resolveRelative(fileData.slug!, page.slug!)} class="internal">
                        {title}
                      </a>
                    </h3>
                  </div>
                  {page.dates && (
                    <p class="meta">
                      <Date date={getDate(cfg, page)!} locale={cfg.locale} />
                    </p>
                  )}
                  {opts.showTags && (
                    <ul class="tags">
                      {tags.map((tag) => (
                        <li>
                          <a
                            class="internal tag-link"
                            href={resolveRelative(fileData.slug!, `tags/${tag}` as FullSlug)}
                          >
                            {tag}
                          </a>
                        </li>
                      ))}
                    </ul>
                  )}
                </div>
              </li>
            )
          })}
        </ul>
        {opts.linkToMore && remaining > 0 && (
          <p>
            <a href={resolveRelative(fileData.slug!, opts.linkToMore)}>
              {i18n(cfg.locale).components.recentNotes.seeRemainingMore({ remaining })}
            </a>
          </p>
        )}
      </div>
    )
  }

  SectionAwareRecentNotes.css = style
  return SectionAwareRecentNotes
}) satisfies QuartzComponentConstructor