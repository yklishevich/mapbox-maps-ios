/// A delegate that responds to annotation selection events.
public protocol AnnotationInteractionDelegate: class {
    func didSelectAnnotation(annotation: Annotation)
    func didDeselectAnnotation(annotation: Annotation)
}
