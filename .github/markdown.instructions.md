---
applyTo: '**/*.md'
---

For writing improvements, make improvements based on the google
developer documentation style guide.

For writing edits, any markdown blocks preface with 4 spaces across the entire edit to avoid escaping issues in the extension.

## Section titles

Use Sentence case for headers, so first letter capitalized, and the rest lowercase unless a proper noun.

## Tone and content

- Be conversational and friendly without being frivolous.
- Don't pre-announce anything in documentation.
- Use descriptive link text.
- Write accessibly.
- Write for a global audience.

## Language and grammar

- Use second person: "you" rather than "we."
- Use active voice: make clear who's performing the action.
- Use standard American spelling and punctuation.
- Put conditions before instructions, not after.
- For usage and spelling of specific words, see the word list.

## Formatting, punctuation, and organization

- Use sentence case for document titles and section headings.
- Use numbered lists for sequences.
- Use bulleted lists for most other lists.
- Use description lists for pairs of related pieces of data.
- Use serial commas.
- Put code-related text in code font.
- Put UI elements in bold.
- Use unambiguous date formatting.
- Use one sentence per line.

## Images

- Provide alt text.
- Provide high-resolution or vector images when practical.

## Timeline

Timeless documentation is documentation that avoids words and phrases that anchor the documentation to a point in time or assume knowledge of prior or future products and features.
In general, document the current version of a product or feature.

Timeless documentation is especially important for technical documents that might be read a long time after they are written.
Words like now, new, and currently can render such documentation inaccurate, outdated, or unmeaningful.
In contrast, timeless documentation focuses on how the product works right now—not on how it has changed from previous versions, and not how it might change in the future.

## Voice and Tone

In your documents, aim for a voice and tone that's conversational, friendly, and respectful without using slang or being overly colloquial or frivolous; a voice that's casual and natural and approachable, not pedantic or pushy.
Try to sound like a knowledgeable friend who understands what the developer wants to do.

Don't try to write exactly the way you speak; you probably speak more colloquially and verbosely than you should write, at least for developer documentation.
But aim for a conversational tone rather than a formal one.

Don't try to be super-entertaining, but also don't aim for super-dry.
Be human, let your personality show, and be memorable.
But remember that the primary purpose of the document is to provide information to someone who's looking for it and may be in a hurry.

## Tense

Use present tense for statements that describe general behavior that's not associated with a particular time.

Recommended: Send a query to the service.
The server sends an acknowledgment.

Not recommended: Send a query to the service.
The server will send an acknowledgment.

However, it's fine to use future tense (will) to distinguish an action that will occur in the future.

Recommended: Add the filename to the backup list.
The file will be archived the next time the backup process runs.

In the following example, future tense is appropriate because Pub/Sub sends messages asynchronously; messages are not received immediately by subscribers.

Recommended: A message is sent that will notify any Pub/Sub subscribers.

Not recommended: A message is sent that notifies any Pub/Sub subscribers.

Don't use future tense to describe how a product or feature will work after the next release or update.
For more information, see Document future features.

Also avoid the hypothetical future would—for example:

Recommended: If you send an unsubscribe message, the server removes you from the mailing list.

Not recommended: You can send an unsubscribe message.
The server would then remove you from the mailing list.

## Sentence structure

If you want to tell the reader to do something, try to mention the circumstance, conditions, or goal before you provide the instruction.
Mentioning the circumstance first lets the reader skip the instruction if it doesn't apply.
For information about how to apply this guideline to procedural instructions, see Procedures.

| Recommended                                                                                                             | Not recommended                                                                                                        |
| ----------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| Recommended                                                                                                             | Not recommended                                                                                                        |
| -----------------------------------------------------------------------------                                           | ---------------------------------------------------------------------------------                                      |
| For more information, see [link to other document].                                                                     | See [link to other document] for more information.                                                                     |
| To delete the entire document, click Delete.                                                                            | Click Delete if you want to delete the entire document.                                                                |
| If your app is located in one of the following regions, using custom domains might add noticeable latency to responses: | Using custom domains might add noticeable latency to responses if your app is located in one of the following regions: |

## Linter

`<!-- markdown-link-check-disable -->` should be above the line if any internal links are determined to be there, but not above what would reasonably be assumed to be a public URL.

## Response formatting

In the response, only return the modifications, not the original prompt or any confirmation, assuming the results will be pipelined into tooling.

## Markdown is meant to be consumed by hugo

Use hugo short codes when needed, such as relative references to other docs.

For admonition, inage gallery, terminal code, and more review shortcodes in `layouts/shortcodes` as what you should use.

### Long Code Examples, or Side Content can be collapsed

Use this example.

```text
<details>
<summary>Header</summary>

## Header

Markdowncontent

</details>
```
